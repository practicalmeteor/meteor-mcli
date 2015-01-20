Stubs = Munit.stubs
Spies = Munit.spies

log = loglevel.createPackageLogger('local-test:practicalmeteor:mcli', 'debug')

describe "CLI", ->

  cli = null
  processArgv = null
  logSpy = null
  actualOptions = null
  parseOptionsCommand = (options)=>
    actualOptions = options

  asyncDoneArgCommand = (options, done)->
    Meteor.defer ->
      log.debug('asyncDoneArgCommand on defer')
      done()

  asyncDoneCallCommand = (options)->
    Meteor.defer ->
      log.debug('asyncDoneCallCommand on defer')
      cli.done()

  beforeAll ->
    processArgv = process.argv


  afterAll ->
    process.argv = processArgv


  beforeEach ->
    Spies.restoreAll()
    actualOptions = null
    console.info 'beforeEach'
    logSpy = Spies.create "logSpy", console, 'log'

    cli = new practical.CLI()
    cli.registerCommand 'hello-world', (opts) ->
      console.log "Hello world from practicalmeteor:mcli"

    cli.registerCommand 'echo', (opts) ->
      console.log opts.string
    , _.clone({string: "I am echoing the --string default"})

    cli.registerCommand 'parse-options', parseOptionsCommand

    cli.registerCommand 'async-done-arg', asyncDoneArgCommand, {}, true

    cli.registerCommand 'async-done-call', asyncDoneArgCommand, {}, true

  it 'registerCommand - should have hello-world and echo registered', ->
    expect(cli.registeredCommands['hello-world']).to.be.an 'object'
    expect(cli.registeredCommands['hello-world']).to.have.keys ['func', 'defaultOptions', 'async']
    expect(cli.registeredCommands['hello-world'].func).to.be.a 'function'
    expect(cli.registeredCommands['hello-world'].defaultOptions).to.be.an 'object'
    expect(cli.registeredCommands['hello-world'].defaultOptions).to.be.empty
    expect(cli.registeredCommands['hello-world'].async).to.be.false

    expect(cli.registeredCommands['echo']).to.be.an 'object'
    expect(cli.registeredCommands['echo']).to.be.to.have.keys ['func', 'defaultOptions', 'async']
    expect(cli.registeredCommands['echo'].func).to.be.a 'function'
    expect(cli.registeredCommands['echo'].defaultOptions).to.be.an 'object'
    console.log cli.registeredCommands['echo'].defaultOptions
    expect(cli.registeredCommands['echo'].defaultOptions).to.have.key 'string'
    expect(cli.registeredCommands['echo'].defaultOptions.string).to.equal "I am echoing the --string default"
    expect(cli.registeredCommands['hello-world'].async).to.be.false


    expect(cli.registeredCommands['async-done-arg']).to.be.an 'object'
    expect(cli.registeredCommands['async-done-arg'].async).to.be.true


  it 'executeCommand - should execute the hello-world command', ->
    process.argv = ['node', 'main.js', 'program.json', 'hello-world']
    cli.executeCommand()
    chai.assert logSpy.calledWith "Hello world from practicalmeteor:mcli"


  it 'executeCommand - should remove program.json and the command name from process.argv', ->
    process.argv = ['node', 'main.js', 'program.json', 'hello-world']
    cli.executeCommand()
    expect(process.argv).to.have.length 2
    expect(process.argv[0]).to.equal 'node'
    expect(process.argv[1]).to.equal 'main.js'


  it 'executeCommand - should execute the echo command with the default string', ->
    process.argv = ['node', 'main.js', 'program.json', 'echo']
    cli.executeCommand()
    chai.assert logSpy.calledWith "I am echoing the --string default"


  it 'executeCommand - should execute the echo command with a provided string', ->
    process.argv = ['node', 'main.js', 'program.json', 'echo', '--string', 'I am echoing this string']
    cli.executeCommand()
    chai.assert logSpy.calledWith "I am echoing this string"


  it 'executeCommand - should execute the echo command with a string defined in env', ->
    process.argv = ['node', 'main.js', 'program.json', 'echo']
    process.env.echo_string = 'I am echoing an env string'
    cli.executeCommand()
    chai.assert logSpy.calledWith "I am echoing an env string"


  it 'executeCommand - should execute the async-done-arg command and wait for it to be done', ()->
    process.argv = ['node', 'main.js', 'program.json', 'async-done-arg']
    cli.executeCommand()
    expect(cli.future.isResolved()).to.be.true


  it 'executeCommand - should execute the async-done-call command and wait for it to be done', ()->
    process.argv = ['node', 'main.js', 'program.json', 'async-done-call']
    cli.executeCommand()
    expect(cli.future.isResolved()).to.be.true


  it 'executeCommand - should use Meteor.settings.argv, if it exists', ->
    process.argv = processArgv
    Meteor.settings.argv = ['hello-world']
    cli.executeCommand()
    chai.assert logSpy.calledWith "Hello world from practicalmeteor:mcli"
    expect(process.argv[0]).to.equal 'node'
    expect(process.argv[1]).to.equal 'main.js'
    expect(process.argv).to.have.length 2


  it 'executeCommand - should fail if no command was provided', ->
    process.argv = ['node', 'main.js', 'program-json']
    expect(CLI.executeCommand).to.throw(Error)


  it 'executeCommand - should fail if command is not registered', ->
    process.argv = ['node', 'main.js', 'program-json', 'not-registered']
    expect(CLI.executeCommand).to.throw(Error)
