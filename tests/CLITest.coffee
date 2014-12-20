Stubs = Munit.stubs
Spies = Munit.spies


describe "CLI", ->

  cli = null
  processArgv = null
  logSpy = null
  actualOptions = null
  parseOptionsCommand = (options)=>
    actualOptions = options

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


  it 'executeCommand - should use Meteor.settings.commandLine, if it exists', ->
    process.argv = processArgv
    Meteor.settings.commandLine = 'hello-world'
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



  it 'commandLine2argv - should parse simple command with no options', ->
    cmd = "parse-options"
    result = cli.commandLine2argv(cmd)
    expectedArgv = ['node','main.js','parse-options']
    expect(result).to.deep.equal(expectedArgv)

  it 'commandLine2argv - should parse simple command with args', ->
    cmd = "parse-options arg1 arg2"
    result = cli.commandLine2argv(cmd)
    expectedArgv = ['node','main.js','parse-options','arg1','arg2']
    expect(result).to.deep.equal(expectedArgv)

  it 'commandLine2argv - should parse a command with options having 2 dashes', ->
    cmd = "parse-options --opt1=val1 --opt2 --opt3 val1 val2 --opt4"
    result = cli.commandLine2argv(cmd)
    expectedArgv = ['node','main.js','parse-options','--opt1','val1','--opt2','--opt3','val1','val2','--opt4']
    expect(result).to.deep.equal(expectedArgv)

  it 'commandLine2argv - should parse a command with options having 1 dash', ->
    cmd = "parse-options -o=val1 -p -t val1 val2 -i"
    result = cli.commandLine2argv(cmd)
    expectedArgv = ['node','main.js','parse-options','-o','val1','-p','-t','val1','val2','-i']
    expect(result).to.deep.equal(expectedArgv)

  it 'commandLine2argv - should parse a command with options having 1 and 2 dashes', ->
    cmd = "parse-options --opt1=val1 --opt2 -o val1 val2 -p"
    result = cli.commandLine2argv(cmd)
    expectedArgv = ['node','main.js','parse-options','--opt1','val1','--opt2','-o','val1','val2','-p']
    expect(result).to.deep.equal(expectedArgv)

  it 'commandLine2argv - should parse a command with options and args', ->
    cmd = "parse-options --opt1=val1 --opt2 -o val1 val2 -p arg1 arg2"
    result = cli.commandLine2argv(cmd)
    expectedArgv = ['node','main.js','parse-options','--opt1','val1','--opt2','-o','val1','val2','-p','arg1','arg2']
    expect(result).to.deep.equal(expectedArgv)

  it 'commandLine2argv - should parse a very complex command', ->
    cmd = "parse-options --opt1=val1 --opt2 -o \"val1 val2\" -Rfj --opt4='val1 val2 val3' -p val1 arg1 arg2"
    result = cli.commandLine2argv(cmd)
    expectedArgv = ['node','main.js','parse-options','--opt1','val1','--opt2','-o','val1 val2', '-Rfj','--opt4','val1 val2 val3','-p','val1','arg1','arg2']
    expect(result).to.deep.equal(expectedArgv)

  it 'commandLine2argv - trim single and quotes', ->
    cmd = "parse-options --opt1=val1 --opt2 -o \"val1 val'2\" -Rfj --opt4='val1 val2 val3' -p val1 arg1 arg2"
    result = cli.commandLine2argv(cmd)
    expectedArgv = ['node','main.js','parse-options','--opt1','val1','--opt2','-o',"val1 val'2", '-Rfj','--opt4','val1 val2 val3','-p','val1','arg1','arg2']
    expect(result).to.deep.equal(expectedArgv)


  it 'executeCommand - should parse a very complex command', ->
    cmd = "parse-options --opt1=val1 --opt2 -o \"val1 val2\" -Rfj --opt4='val1 val2 val3' -p val1 arg1 arg2"
    Meteor.settings.commandLine = cmd
    cli.executeCommand()
    expect(process.argv).to.deep.equal(['node','main.js','--opt1','val1','--opt2','-o','val1 val2', '-Rfj','--opt4','val1 val2 val3','-p','val1','arg1','arg2'])

