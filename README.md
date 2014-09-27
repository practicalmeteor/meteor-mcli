[![Build Status](https://travis-ci.org/spacejamio/meteor-mcli.svg?branch=master)](https://travis-ci.org/spacejamio/meteor-mcli)
spacejamio:mcli
--------------
## Overview

A meteor package and command line tools for creating and running command line / cli programs with meteor.

## Incentive

To be able to reuse the same code of your meteor app in your command line programs, instead of having to create a separate node / npm code base with lot's of code duplication with your meteor app.

## Quickstart

```
# jq is a command-line JSON processor that the mcli command line tool depends on.
# Replace the first line with your linux's distribution way of installing packages.
sudo apt-get install -y jq

curl https://raw.githubusercontent.com/spacejamio/meteor-mcli/master/bin/install-starter-kit.sh | bash

cd starter-mcli-app

# Run the hello-world command in the meteor command line program.
mcli hello-world
```

The starter-mcli-app is a fully functional meteor command line program that you should use as a base.

## API

You can include multiple commands in a single meteor command line program. To register your commands:

```
# defaultOptions is optional
CLI.registerCommand(commandName, functionToExecute, defaultOptions);
```

For example:

```
var defaultOptions = { stderr: false };

var helloWorld = function(options) {
  if(options.stderr)
    console.error("Hello world from spacejamio:mcli!");
  else
    console.info("Hello world from spacejamio:mcli!");
};

CLI.registerCommand('hello-world', helloWorld, defaultOptions);
```

To run your command, just:

```
# Run this from your meteor command line program folder.
mcli hello-world --stderr=true
```

Or, with a meteor settings file:

```
mcli --settings my-settings.json hello-world --stderr=true
```

You have more examples of commands, including commands that take command line arguments as well as options, in the [starter-mcli-app](starter-mcli-app/server) command line program.

## Command Line Options, Defaults and Arguments

spacejamio:mcli uses the excellent [rc](https://www.npmjs.org/package/rc) npm command line parser and configurator.

When you register your command, you provide a json object with default values only for command line options you want default values for. When your command is called, it will get an options json object that will include all the options specified on the command line, as well as defaults you specified for options that were not included.

Command line options can also be specified using environment variables, prefixed with your command name, i.e. for the hello-world example above, before running your program, you can:

```
export hello_world_stderr=true
```

Note that you will need to replace '-' in command names with '_' in your environment variables.

Arguments provided on the command line are stored in the 'options._' array. An example can be found [here](starter-mcli-app/EchoCommand.js).

## Executing commands in a meteor build

You can execute your commands in a meteor build by appending them to the standard meteor node command line, i.e.

```
node main.js hello-world --stderr=true
```
  
mcli-bundle can be used to test your commands are working in a meteor build before deployment to production, by running:

```
mcli-bundle hello-world --stderr=true
```

It will build your meteor program, extract it to a /tmp folder, install the npm packages and run your command, as above. You can also specify a settings file:

```
mcli-bundle --settings my-settings.json hello-world --stderr=true
```

In this case, mcli-bundle will automatically set the METEOR_SETTINGS environment variable to the contents of your settings file.

## The hard way (i.e. creating your meteor cli app from scratch)

- Create your meteor app the standard way.

- Run:

```
# Meteor command line programs cannot include the webapp package, 
# as well as client side packages
meteor remove meteor-platform

# Add the meteor core
meteor add meteor

# Add mongo to access mongodb collections
meteor add mongo

# Add application-configuration to access 3rd party services
meteor add application-configuration

# Add spacejamio:mcli
meteor add spacejamio:mcli
```

- meteor apps expect a main function which is the entry point to the app. The meteor webapp package provides just that. In a cli program, you will need to create your own main function that calls CLI.executeCommand, as in [here](starter-mcli-app/server/main.js).

- Install the jq json command line processor:

```
# Replace the first line with your linux's distribution way of installing packages.
sudo apt-get install -y jq
```

- Install the mcli and mcli-bundle tools:

```
curl https://raw.githubusercontent.com/spacejamio/meteor-mcli/master/bin/install-mcli.sh | bash
```

## How it works

Since in local development mode, meteor cannot accept command line arguments, the mcli tool creates or extends your meteor settings file and adds the specified command line to Meteor.settings.commandLine. The spacejamio:cli package will read the command line from this setting, if it exists, or the normal way (with some meteor specific manipulation) from process.argv in a meteor build.

## License
[MIT](LICENSE.txt)

## Contributions
Are more than welcome. Would be nice to have an a meteor cli app scaffolding tool, among others.
