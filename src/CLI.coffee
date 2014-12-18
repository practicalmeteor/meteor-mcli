rc = Npm.require('rc')

@practical ?= {}

class practical.CLI

  @instance: null

  registeredCommands: { }

  @get:->
    practical.CLI.instance ?= new CLI()

  constructor: ->
    log.debug("NODE_ENV=#{process.env.NODE_ENV}")

  commandLine2argv: (commandLine)->
    # Having commandLine: "test-cmd --opt1=val1 --opt2 -opt3 val1 val2 --opt4=val1 val2 val3 -opt5=val1 arg1 arg2"
    # Separate command from options (in case it has a dash)
    parts = commandLine.split(/^([\w\-]+)/)
    # Now we have: ['', 'test-cmd', '--opt1=val1 --opt2 -opt3 val1 val2 --opt4=val1 val2 val3 -opt5=val1 arg1 arg2']

    # if the command has options
    if parts[2]
      # Split each option
      # Result: ["-", "-opt1=val1 ", "-", "-opt2 ", "-opt3 val1 val2 ", "-", "-opt4=val1 val2 val3 ", "-opt5=val1 arg1 arg2"]
      # This separates double dash too but they are joined later.
      argv = parts[2].trim().split(/(?=-+)/);

      # This splits the args of command from the last element of the array:
      # After concat we have: ["-", "-opt1=val1 ", "-", "-opt2 ", "-opt3 val1 val2 ", "-", "-opt4=val1 val2 val3 ", "-opt5=val1", "arg1", "arg2"]
      argv = argv.concat(argv.pop().split(" "));

      len = argv.length
      # We need the by 1 because the length changes due to splices, so if the length is being reduced it doesn't increment
      for i in [0...len] by 1
        # in case the option has 2 dashes they must be joined back
        # Iterating the array of options we have to join the dashes only in case of double dash option
        # Converting: ["-","-opt1"] Into: ["--opt1"]
        argv[i] = argv.splice(i,1) + argv[i] if argv[i] is "-"

        # removing space of options
        argv[i] = argv[i].trim()
        
        # Resetting length because using the splice above it changes.
        len = argv.length

    else argv = [] # If command doesn't have options...

    # Adding command back
    argv.unshift(parts[1])
    # This is not a meteor bundle, commandLine was provided in Meteor.settings,
    # so we need to add 'node main.js' so rc will function properly.
    argv.unshift("main.js")
    argv.unshift("node")

    process.argv = argv


  executeCommand: ->
    log.debug('CLI.executeCommand()', process.argv)

    commandLine = Meteor?.settings?.commandLine

    if commandLine
      @commandLine2argv(commandLine)
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

    options = rc(commandName.replace('-', '_'), command.defaultOptions)

    log.debug("Executing '#{commandName}' with options:\n", options)

    # Execute the registered command
    command.func options


  # Note: defaultOptions will be mutated by actual command line options.
  registerCommand: (name, func, defaultOptions = {}) ->
    log.debug("CLI.registerCommand()")
    expect(name, "command name is missing").to.be.a("string")
    expect(func, "command function is missing").to.be.a("function")
    expect(defaultOptions, "command defaultOptions is not an object").to.be.a("object")

    log.debug("Registering '#{name}' with default options:\n", defaultOptions)

    @registeredCommands[name] = { func: func, defaultOptions: defaultOptions }


CLI = practical.CLI.get()
