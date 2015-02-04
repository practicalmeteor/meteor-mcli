var mainCalled = false;

main = function() {
  if (mainCalled) {
    log.error("Error: main was already called!");
    process.exit(1);
  }

  try {
    mainCalled = true;
    return CLI.executeCommand();
  } catch (err) {
    if(err instanceof Object) {
      log.error(JSON.stringify(err, null, 2));
    } else {
      log.error(err);
    }
    process.exit(1);
  }
};
