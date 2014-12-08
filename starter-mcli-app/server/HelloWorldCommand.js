CLI.registerCommand('hello-world', function(options) {
  if(options.stderr)
    console.error("Hello world from practicalmeteor:mcli!");
  else
    console.info("Hello world from practicalmeteor:mcli!");
});
