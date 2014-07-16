class CLISingleton

  instance = null

  class _CLI

    executeCommand: ->


    registerCommand: (name, command, defaultOptions) ->

  @get:->
    instance ?= new _CLI()

@CLI = CLISingleton.get()