// Example of an async command that spawns an ls child process,
// waits for it to exit, and then calls CLI.done()

var log = loglevel.createLogger('ls', 'debug');

var child_process = Npm.require('child_process');

// When you register your command as an async one,
// you need to call CLI.done() when your command has completed.
var lsCommand = function(options) {

  log.debug('spawning ls');
  var ls = child_process.spawn("ls");
  log.debug('ls spawned');

  ls.stdout.setEncoding("utf8");
  ls.stdout.on("data", function(data){
    process.stdout.write(data);
  });

  ls.stderr.setEncoding("utf8");
  ls.stderr.on("data", function(data){
    process.stderr.write(data);
  });

  // You need to wait on a child process's close event, and not on it's exit event,
  // to make sure it has exited and all it's output has been delivered to you.
  ls.on("close", function(code, signal){
    log.debug('ls closed');
    // Calling CLI.done() will let CLI know your command has completed and it can exit.
    CLI.done();
  });
};

// When registering an async command, pass in true as the last argument.
CLI.registerCommand('ls', lsCommand, {}, true);
