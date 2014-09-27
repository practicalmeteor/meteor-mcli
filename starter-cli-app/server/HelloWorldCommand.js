CLI.registerCommand('hello-world', function(options) {
  if(options.stderr)
    console.error(options.prefix + string);
  else
    console.info(options.prefix + string);
});
