Stubs = Munit.stubs

describe "CLITest", ->

  beforeAll ->

  beforeEach ->
    Meteor.settings.commandLine = "--command world-domination --opt"

  it 'should fail if Meteor.settings.commandLine doesnt exist', ->
    Meteor.settings.commandLine = undefined
    expect(CLI.executeCommand).to.throw(Error)

  it 'should not fail if Meteor.settings.commandLine exist', ->
    expect(CLI.executeCommand).not.to.throw(Error)

  it 'should put Meteor.settings.commandLine in process.argv', ->
    CLI.executeCommand()
    expectedArray = Meteor.settings.commandLine.split(" ")
    expectedArray.unshift(" ")
    expectedArray.unshift(" ")
    expect(process.argv).to.be.eql(expectedArray)

  it 'should fail if command option is not present', ->
    Meteor.settings.commandLine = "--opt"
    expect(CLI.executeCommand).to.throw(Error)

  it 'should not fail if command option is present', ->
    expect(CLI.executeCommand).not.to.throw(Error)
