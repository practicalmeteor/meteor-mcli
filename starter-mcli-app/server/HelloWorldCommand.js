CLI.registerCommand('hello-world', function(options) {
  if(options.stderr)
    console.error("Hello world from spacejamio:mcli!");
  else
    console.info("Hello world from spacejamio:mcli!");
});
