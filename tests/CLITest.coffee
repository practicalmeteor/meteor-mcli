Stubs = Munit.stubs

describe "CLITest", ->

  beforeAll ->
    CLI.registeredCommands = { 'world-domination': { commandFunction: undefined, defaultOptions: { } } }


  beforeEach ->
    Meteor.settings.commandLine = "--command world-domination --opt"


  it 'CLI.executeCommand - should fail if Meteor.settings.commandLine doesnt exist', ->
    Meteor.settings.commandLine = undefined
    expect(CLI.executeCommand).to.throw(Error)


  it 'CLI.executeCommand - should put Meteor.settings.commandLine in process.argv', ->
    CLI.executeCommand()
    expectedArray = Meteor.settings.commandLine.split(" ")
    expectedArray.unshift(" ")
    expectedArray.unshift(" ")
    expect(process.argv).to.be.eql(expectedArray)


  it 'CLI.executeCommand - should fail if command option is not present', ->
    Meteor.settings.commandLine = "--opt"
    expect(CLI.executeCommand).to.throw(Error)


  it 'CLI.executeCommand - should fail if the command is not registered', ->
    CLI.registeredCommands = { }
    expect(CLI.executeCommand).to.throw(Error)


  it 'CLI.registerCommand - should fail if any of the arguments is missing', ->
    expect(CLI.registerCommand).to.throw(Error)


  it 'CLI.registerCommand - should save the command into registeredCommands', ->
    CLI.registeredCommands = { }

    worldDominationStub = sinon.stub().returns(42)
    defaultOptions = { now: true }

    CLI.registerCommand("world-domination", worldDominationStub, defaultOptions)

    expect(CLI.registeredCommands).to.have.property("world-domination")
    expect(CLI.registeredCommands["world-domination"]).to.have.property("commandFunction")
    expect(CLI.registeredCommands["world-domination"].commandFunction).to.be.eql(worldDominationStub)
    expect(CLI.registeredCommands["world-domination"].defaultOptions).to.be.eql(defaultOptions)

