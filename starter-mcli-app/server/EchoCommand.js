// If called without --prefix, the default prefix will be used.
// To print to stderr, set '--stderr=true'
var defaultOptions = {
  prefix: "prefix:",
  stderr: false
};

var echoCommand = function(options) {
  var string = "No string to echo was provided.";
  if(options._ && options._.length > 0)
    string = options._.join(' ');

  msg = options.prefix + ' ' + string;

  if(options.postfix)
    msg += ' ' + options.postfix;

  if(options.stderr)
    console.error(msg);
  else
    console.info(msg);
};

CLI.registerCommand('echo', echoCommand, defaultOptions);
