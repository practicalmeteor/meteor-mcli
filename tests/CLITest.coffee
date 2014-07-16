Stubs = Munit.stubs

describe "CLITest", ->

  beforeAll ->

  beforeEach ->

  it 'should fail if Meteor.settings.commandLine doesnt exist', ->
    expect(CLI.executeCommand).to.throw(Error)

