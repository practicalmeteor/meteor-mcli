[![Build Status](https://travis-ci.org/practicalmeteor/meteor-mcli.svg?branch=master)](https://travis-ci.org/practicalmeteor/meteor-mcli)
practicalmeteor:mcli
--------------
## Overview

A meteor package and command line tools for creating and running command line / cli programs with meteor.

## Incentive

To be able to reuse the same code of your meteor app in your command line programs, instead of having to create a separate node / npm code base with lot's of code duplicated from your meteor app.

## Quickstart

```bash

# jq is a command-line JSON processor that the mcli command line tool depends on.
# Replace the first line with your linux's distribution way of installing packages.
sudo apt-get install -y jq

curl https://raw.githubusercontent.com/practicalmeteor/meteor-mcli/master/bin/install-starter-kit.sh | bash

cd starter-mcli-app

# Run the hello-world command in the meteor command line program.
mcli hello-world
```

The starter-mcli-app is a fully functional meteor command line program that you should use as a base.

## API

You can include multiple commands in a single meteor command line program. To register your commands:

```javascript

// defaultOptions and async are optional
CLI.registerCommand(commandName, functionToExecute, defaultOptions = {}, async = false);
```

For example:

```javascript

var defaultOptions = { stderr: false };

var helloWorld = function(options) {
  if(options.stderr)
    console.error("Hello world from practicalmeteor:mcli!");
  else
    console.info("Hello world from practicalmeteor:mcli!");
};

CLI.registerCommand('hello-world', helloWorld, defaultOptions);
```

To run your command, just:

```bash

# Run this from your meteor command line program folder.
mcli hello-world --stderr=true
```

Or, with a meteor settings file:

```bash

mcli --settings my-settings.json hello-world --stderr=true
```

## Async Commands API

Unlike a meteor webapp, which never exits and therefore your async callbacks will always execute, command line programs with async callbacks will exit, unless you tell them not to using [futures](https://github.com/laverdet/node-fibers) or mcli's simplified async API based on futures.

Here is an example async [ls](https://github.com/practicalmeteor/meteor-mcli/blob/master/starter-mcli-app/server/LsCommand.js) command from the starter-mcli-app:

```javascript

var child_process = Npm.require('child_process');

// When you register your command as an async one,
// your command will be called with a done function as a 2nd argument
// which you need to call when your command has completed.
var lsCommand = function(options, done) {

  var ls = child_process.spawn("ls");

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
    // Call done() to let CLI know your command has completed and it can exit.
    // You can also call CLI.done() instead
    done();
  });
};

// When registering an async command, pass in true as the last argument.
CLI.registerCommand('ls', lsCommand, {}, true);
```

## Additional Examples

You have additional examples of commands, including commands that take command line arguments as well as options, in the [starter-mcli-app](https://github.com/practicalmeteor/meteor-mcli/tree/master/starter-mcli-app/server) command line program.

## Command Line Options, Defaults and Arguments

practicalmeteor:mcli uses the excellent [rc](https://www.npmjs.org/package/rc) npm command line parser and configurator.

When you register your command, you provide a json object with default values only for command line options you want default values for. When your command is called, it will get an options json object that will include all the options specified on the command line, as well as defaults you specified for options that were not included.

Command line options can also be specified using environment variables, prefixed with your command name, i.e. for the hello-world example above, before running your program, you can:

```bash

export hello_world_stderr=true
```

Note that you will need to replace '-' in command names with '_' in your environment variables.

Arguments provided on the command line are stored in the 'options._' array. An example can be found [here](https://github.com/practicalmeteor/meteor-mcli/blob/master/starter-mcli-app/server/EchoCommand.js).

## Using the same mongodb in your web app and your command line program(s)

In development mode, every meteor app has it's own internal mongodb that is located inside an app's .meteor/local folder.

Therefore, if you want to share a mongodb between your webapp and your command line programs, you will need to use an external mongodb and export the MONGO_URL environment variable so your meteor apps can connect to it. You  can get a free sandbox database from [compose.io](https://www.compose.io/) (formerly mongohq), but there are other alternatives out there.

## Executing commands in a meteor build

You can execute your commands in a meteor build by appending them to the standard meteor node command line, i.e.

```bash

node main.js hello-world --stderr=true
```
  
mcli-bundle can be used to test your commands are working in a meteor build before deployment to production, by running:

```bash

mcli-bundle hello-world --stderr=true
```

It will build your meteor program, extract it to a /tmp folder, install the npm packages and run your command, as above. You can also specify a settings file:

```bash

mcli-bundle --settings my-settings.json hello-world --stderr=true
```

In this case, mcli-bundle will automatically set the METEOR_SETTINGS environment variable to the contents of your settings file.

## The hard way (i.e. creating your meteor mcli app from scratch)

- Create your meteor app the standard way.

- Run:

```bash

# Meteor command line programs cannot include the webapp package, 
# as well as client side packages
meteor remove meteor-platform

# Add the meteor core
meteor add meteor

# Add mongo to access mongodb collections
meteor add mongo

# Add application-configuration to access 3rd party services
meteor add application-configuration

# Add practicalmeteor:mcli
meteor add practicalmeteor:mcli
```

- meteor apps expect a main function which is the entry point to the app. The meteor webapp package provides just that. In a cli program, you will need to create your own main function that calls CLI.executeCommand, as in [here](https://github.com/practicalmeteor/meteor-mcli/blob/master/starter-mcli-app/server/main.js).

- Install the jq json command line processor:

```bash

# Replace the first line with your linux's distribution way of installing packages.
sudo apt-get install -y jq
```

- Install the mcli and mcli-bundle tools:

```bash

curl https://raw.githubusercontent.com/practicalmeteor/meteor-mcli/master/bin/install-mcli.sh | bash
```

## How it works

Since in local development mode, meteor cannot accept command line arguments, the mcli tool creates or extends your meteor settings file and adds the specified command line arguments as an array to Meteor.settings.argv. The practicalmeteor:cli package will read the command line from this setting, if it exists, or the normal way (with some meteor specific manipulation) from process.argv in a meteor build.

## Changelog

[CHANGELOG](https://github.com/practicalmeteor/meteor-mcli/blob/master/CHANGELOG.md)

## License
[MIT](https://github.com/practicalmeteor/meteor-mcli/blob/master/LICENSE.txt)

## Contributions
Are more than welcome. Would be nice to:
 
- Connect to the internal meteor mongodb database of a running meteor app.

- Start and stop the internal meteor mongodb database, if a meteor app is not running.

- Have a meteor mcli app scaffolding tool.
