Npm.depends({
    'rc': '0.5.1'
});


Package.describe({
  summary: "A package and tools for creating and running command line / cli programs with meteor.",
  name: "spacejamio:mcli",
  version: "1.0.0",
  git: "https://github.com/spacejamio/meteor-mcli.git"
});


Package.on_use(function (api, where) {
  api.versionsFrom('0.9.0');

  api.use(["coffeescript", "underscore", "spacejamio:chai"], "server");

  api.addFiles("MeteorNoops.coffee", 'server');
  api.add_files("CLI.coffee", "server");

  api.export("CLI", "server");
});


Package.on_test(function(api) {
  api.use(["coffeescript", "spacejamio:mcli", "spacejamio:munit"], 'server');
  api.add_files("tests/CLITest.coffee", "server")
});
