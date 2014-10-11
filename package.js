Npm.depends({
    'rc': '0.5.1'
});


Package.describe({
  summary: "A package and tools for creating and running command line / cli programs with meteor.",
  name: "spacejamio:mcli",
  version: "1.1.0",
  git: "https://github.com/spacejamio/meteor-mcli.git"
});


Package.onUse(function (api) {
  api.versionsFrom('0.9.3');

  api.use(["coffeescript", "underscore", "spacejamio:chai@1.9.2_1"], "server");

  api.addFiles("MeteorNoops.coffee", 'server');
  api.add_files("CLI.coffee", "server");

  api.export("CLI", "server");
});


Package.onTest(function(api) {
  api.use(["coffeescript", "spacejamio:mcli", "spacejamio:munit@2.0.0"], 'server');
  api.add_files("tests/CLITest.coffee", "server")
});
