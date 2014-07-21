class CLISingleton

  instance = null

  class CLI

    registeredCommands: { }

    rc = Npm.require('rc')

    executeCommand: ->
      expect(Meteor.settings.commandLine).to.exist

      process.argv = Meteor.settings.commandLine.split(" ")
      #following node convetions rc expects the two first process.argv to be node and the node program, and removes them from the conf object
      #refer to http://nodejs.org/docs/latest/api/process.html#process_process_argv
      #So we prepend two whitespaces
      process.argv.unshift(" ")
      process.argv.unshift(" ")

      opts = rc('meteor-cli', { })

      commandName = opts.command
      expect(commandName).to.be.a("string")

      command = @registeredCommands[commandName]
      expect(command).to.be.a("object")

      defaultOptions = command.defaultOptions

      opts = rc('meteor-cli', defaultOptions)

      try
        command.func opts
      catch error
        console.log error
        process.exit 1


    registerCommand: (name, func, defaultOptions = { }) ->
      expect(name).to.be.a("string")
      expect(func).to.be.a("function")
      expect(defaultOptions).to.be.a("object")

      @registeredCommands[name] = { func: func, defaultOptions: defaultOptions }

  @get:->
    instance ?= new CLI()

@CLI = CLISingleton.get()