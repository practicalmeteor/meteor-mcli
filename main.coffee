mainCalled = false;

@main: ->
  if (mainCalled)
    console.error "main function already called before"
    process.exit 1

  mainCalled = true

  try
    CLI.executeCommand()
  catch err
    console.error err
    process.exit 1

