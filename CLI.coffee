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
      process.argv = Meteor.settings.commandLine.split(" ")
      # In a meteor bundle, the first arg is node, the 2nd main.js, and the 3rd program.json
      process.argv.unshift("program.json")
      process.argv.unshift("main.js")
      process.argv.unshift("node")

    console.log process.argv.join(' ')

      # THe first arg after is always the name of the command to execute.

    expect(process.argv, "No command specified").to.to.have.length.above(3)

    commandName = process.argv[3]

    command = @registeredCommands[commandName]
    expect(command, "#{commandName} is not a registered cli command").to.to.be.an 'object'

    opts = rc(commandName.replace('-', '_').toUpperCase(), command.defaultOptions)

    command.func opts


  # Note: defaultOptions will be mutated by actual command line options.
  registerCommand: (name, func, defaultOptions = {}) ->
    expect(name, "command name is missing").to.be.a("string")
    expect(func, "command function is missing").to.be.a("function")
    expect(defaultOptions, "command defaultOptions is not an object").to.be.a("object")

    @registeredCommands[name] = { func: func, defaultOptions: defaultOptions }


@CLI = spacejamio.CLI.get()
