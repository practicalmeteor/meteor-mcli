var mainCalled = false;

main = function() {
  //console.debug(process.argv);
  if (mainCalled) {
    throw new Error("main was already called!");
  }

  CLI.executeCommand();
};
