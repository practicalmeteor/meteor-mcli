// If called without --prefix, the default prefix will be used.
// To print to stderr, set '--stderr=true'
var defaultOptions = {
  prefix: "spacejamio:cli - ",
  stderr: false
};

var echoCommand = function(options) {
  // We use the meteor logging package, instead of console.log and console.error
  var string = "No string to echo was provided.";
  if(options._ && options._.length > 0)
    string = options._.join(' ');

  if(options.stderr)
    console.error(options.prefix + string);
  else
    console.info(options.prefix + string);
};

CLI.registerCommand('echo', echoCommand, defaultOptions);
