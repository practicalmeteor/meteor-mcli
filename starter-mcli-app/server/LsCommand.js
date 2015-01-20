// Example of an async command that spawns an ls child process,
// waits for it to exit, and then calls done

var log = loglevel.createLogger('ls', 'debug');

var child_process = Npm.require('child_process');

var lsCommand = function(options, done) {

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

  ls.on("close", function(code, signal){
    // Or, you can call CLI.done() instead
    log.debug('ls closed');
    done();
  });
};

CLI.registerCommand('ls', lsCommand, {}, true);
