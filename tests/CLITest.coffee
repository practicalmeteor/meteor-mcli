Stubs = Munit.stubs
Spies = Munit.spies


describe "CLITest", ->

  cli = null
  processArgv = null
  logSpy = null


  beforeAll ->
    processArgv = process.argv


  afterAll ->
    process.argv = processArgv


  beforeEach ->
    Spies.restoreAll()
    console.info 'beforeEach'
    logSpy = Spies.create "logSpy", console, 'log'

    cli = new spacejamio.CLI()
    cli.registerCommand 'hello-world', (opts) ->
      console.log "Hello world from spacejamio:cli"

    cli.registerCommand 'echo', (opts) ->
      console.log opts.string
    , _.clone({string: "I am echoing the --string default"})
    # We're cloning because rc mutates it's objects


  it 'registerCommand - should have hello-world and echo registered', ->
    expect(cli.registeredCommands['hello-world']).to.be.an 'object'
    expect(cli.registeredCommands['hello-world']).to.be.to.have.keys ['func', 'defaultOptions']
    expect(cli.registeredCommands['hello-world'].func).to.be.a 'function'
    expect(cli.registeredCommands['hello-world'].defaultOptions).to.be.an 'object'
    expect(cli.registeredCommands['hello-world'].defaultOptions).to.be.empty

    expect(cli.registeredCommands['echo']).to.be.an 'object'
    expect(cli.registeredCommands['echo']).to.be.to.have.keys ['func', 'defaultOptions']
    expect(cli.registeredCommands['echo'].func).to.be.a 'function'
    expect(cli.registeredCommands['echo'].defaultOptions).to.be.an 'object'
    console.log cli.registeredCommands['echo'].defaultOptions
    expect(cli.registeredCommands['echo'].defaultOptions).to.have.key 'string'
    expect(cli.registeredCommands['echo'].defaultOptions.string).to.equal "I am echoing the --string default"


  it 'executeCommand - should execute the hello-world command', ->
    process.argv = ['node', 'main.js', 'program-json', 'hello-world']
    cli.executeCommand()
    chai.assert logSpy.calledWith "Hello world from spacejamio:cli"


  it 'executeCommand - should execute the echo command with the default string', ->
    process.argv = ['node', 'main.js', 'program-json', 'echo']
    cli.executeCommand()
    chai.assert logSpy.calledWith "I am echoing the --string default"


  it 'executeCommand - should execute the echo command with a provided string', ->
    process.argv = ['node', 'main.js', 'program-json', 'echo', '--string', 'I am echoing this string']
    cli.executeCommand()
    chai.assert logSpy.calledWith "I am echoing this string"


  it 'executeCommand - should use Meteor.settings.commandLine, if it exists', ->
    process.argv = processArgv
    Meteor.settings.commandLine = 'hello-world'
    cli.executeCommand()
    chai.assert logSpy.calledWith "Hello world from spacejamio:cli"
    expect(process.argv[0]).to.equal 'node'
    expect(process.argv[1]).to.equal 'main.js'
    expect(process.argv[2]).to.equal 'program.json'
    expect(process.argv[3]).to.equal 'hello-world'


  it 'executeCommand - should fail if no command was provided', ->
    process.argv = ['node', 'main.js', 'program-json']
    expect(CLI.executeCommand).to.throw(Error)


  it 'executeCommand - should fail if command is not registered', ->
    process.argv = ['node', 'main.js', 'program-json', 'not-registered']
    expect(CLI.executeCommand).to.throw(Error)
