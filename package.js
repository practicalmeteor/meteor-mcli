Npm.depends({
    'rc': '0.5.1'
});

Package.describe({
  summary: "Package for creating cli programs with meteor",
  name: "spacejamio:cli",
  version: "0.2.0",
  git: "https://github.com/spacejamio/meteor-cli.git"
});

Package.on_use(function (api, where) {
  api.versionsFrom('0.9.0');

  api.use(["coffeescript", "underscore", "logging", "spacejamio:chai"], "server");

  api.addFiles("MeteorNoops.coffee", 'server');
  api.add_files("CLI.coffee", "server");
});

Package.on_test(function(api) {
  api.use(["coffeescript", "spacejamio:cli", "spacejamio:munit"], 'server');
  api.add_files("tests/CLITest.coffee", "server")
});
