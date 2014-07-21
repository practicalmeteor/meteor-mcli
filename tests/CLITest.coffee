myCommandFunctionStub = sinon.stub().returns(42)

describe "CLITest", ->

  beforeEach ->
    CLI.registeredCommands = { 'my-command': { func: myCommandFunctionStub, defaultOptions: { opt1: true } } }
    Meteor.settings.commandLine = "--command my-command --opt2"


  it 'CLI.executeCommand - should fail if Meteor.settings.commandLine doesnt exist', ->
    Meteor.settings.commandLine = undefined
    expect(CLI.executeCommand).to.throw(Error)


  it 'CLI.executeCommand - should put Meteor.settings.commandLine in process.argv', ->
    CLI.executeCommand()
    expectedArray = Meteor.settings.commandLine.split(" ")
    expectedArray.unshift(" ")
    expectedArray.unshift(" ")
    expect(process.argv).to.be.eql(expectedArray)


  it 'CLI.executeCommand - should fail if command name is not present', ->
    Meteor.settings.commandLine = "--opt2"
    expect(CLI.executeCommand).to.throw(Error)


  it 'CLI.executeCommand - should fail if the command is not registered', ->
    CLI.registeredCommands = { }
    expect(CLI.executeCommand).to.throw(Error)


  it 'CLI.executeCommand - should call the command function with the options', ->
    CLI.executeCommand()
    expectedOptions = { _: [], command: "my-command", opt1: true, opt2: true }
    expect(myCommandFunctionStub).to.have.been.calledWith(expectedOptions)


  it 'CLI.registerCommand - should fail if any of the arguments is missing', ->
    expect(CLI.registerCommand).to.throw(Error)


  it 'CLI.registerCommand - should save the command into CLI.registeredCommands', ->
    CLI.registeredCommands = { }

    defaultOptions = { now: true }

    CLI.registerCommand("my-command", myCommandFunctionStub, defaultOptions)

    expect(CLI.registeredCommands).to.have.property("my-command")
    expect(CLI.registeredCommands["my-command"].func).to.be.eql(myCommandFunctionStub)
    expect(CLI.registeredCommands["my-command"].defaultOptions).to.be.eql(defaultOptions)

