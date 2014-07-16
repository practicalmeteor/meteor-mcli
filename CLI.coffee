class CLISingleton

  instance = null

  class _CLI

    executeCommand: ->
      expect(Meteor.settings.commandLine).to.exist

      process.argv = Meteor.settings.commandLine.split(" ")
      #following node convetions rc expects the two first process.argv to be node and the node program, and removes them from the conf object
      #refer to http://nodejs.org/docs/latest/api/process.html#process_process_argv
      #So we prepend two whitespaces
      process.argv.unshift(" ")
      process.argv.unshift(" ")

      opts = Npm.require('rc')('meteor-cli', { })
      console.log(opts)
      console.log(process.argv)

      expect(opts.command).to.exist

    registerCommand: (name, command, defaultOptions) ->

  @get:->
    instance ?= new _CLI()

@CLI = CLISingleton.get()