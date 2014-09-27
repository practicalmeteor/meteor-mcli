var mainCalled = false;

main = function() {
  if (mainCalled) {
    throw new Error("main was already called!");
  }

  CLI.executeCommand();
};
