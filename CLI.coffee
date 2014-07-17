class CLISingleton

  instance = null

  class _CLI

    registeredCommands: { }


    executeCommand: ->
      expect(Meteor.settings.commandLine).to.exist

      process.argv = Meteor.settings.commandLine.split(" ")
      #following node convetions rc expects the two first process.argv to be node and the node program, and removes them from the conf object
      #refer to http://nodejs.org/docs/latest/api/process.html#process_process_argv
      #So we prepend two whitespaces
      process.argv.unshift(" ")
      process.argv.unshift(" ")

      opts = Npm.require('rc')('meteor-cli', { })

      command = opts.command
      expect(command).to.exist
      expect(@registeredCommands[command]).to.exist



    registerCommand: (name, commandFunction, defaultOptions = { }) ->
      expect(name).to.be.a("string")
      expect(commandFunction).to.be.a("function")
      expect(defaultOptions).to.be.a("object")

      @registeredCommands[name] = { commandFunction: commandFunction, defaultOptions: defaultOptions }

  @get:->
    instance ?= new _CLI()

@CLI = CLISingleton.get()