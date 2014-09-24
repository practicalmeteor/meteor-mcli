rc = Npm.require('rc')

@spacejamio ?= {}

class spacejamio.CLI

  @instance: null

  registeredCommands: { }

  @get:->
    spacejamio.CLI.instance ?= new CLI()

  executeCommand: ->

    commandLine = Meteor?.settings?.commandLine

    if commandLine
      # This is not a meteor bundle, commandLine was provided in Meteor.settings,
      # so we need to add 'node main.js' so rc will function properly.
      process.argv = Meteor.settings.commandLine.split(" ")
      process.argv.unshift("main.js")
      process.argv.unshift("node")
    else
      # In a meteor bundle, the first arg is node, the 2nd main.js, and the 3rd program.json
      # We need to remove program.json, so it will not be interpreted by rc as a command line argument.
      expect(process.argv[2], "program.json was expected at process.argv[2]").to.equal 'program.json'
      process.argv.splice(2, 1)

      # THe first arg after is always the name of the command to execute.

    # Meteor._debug process.argv.join(' ')

    expect(process.argv, "No command specified").to.have.length.above(2)

    commandName = process.argv[2]

    command = @registeredCommands[commandName]
    expect(command, "#{commandName} is not a registered cli command").to.to.be.an 'object'

    # Remove the command, so rc doesn't interpret it as a command line argument.
    process.argv.splice(2, 1)

    opts = rc(commandName.replace('-', '_').toUpperCase(), command.defaultOptions)

    # Execute the registered command
    command.func opts


  # Note: defaultOptions will be mutated by actual command line options.
  registerCommand: (name, func, defaultOptions = {}) ->
    expect(name, "command name is missing").to.be.a("string")
    expect(func, "command function is missing").to.be.a("function")
    expect(defaultOptions, "command defaultOptions is not an object").to.be.a("object")

    @registeredCommands[name] = { func: func, defaultOptions: defaultOptions }


@CLI = spacejamio.CLI.get()
