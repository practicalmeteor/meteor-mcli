Npm.depends({
    'rc': '0.4.0'
});

Package.describe({
  summary: "Package for creating cli programs with meteor",
  name: "spacejamio:cli",
  version: "0.2.0",
  git: "https://github.com/spacejamio/meteor-cli.git"
});

Package.on_use(function (api, where) {
  api.versionsFrom('0.9.0');

  api.use(["coffeescript", "underscore", "spacejamio:chai"], "server");

  api.addFiles("MeteorNoops.coffee", 'server');
  api.add_files("CLI.coffee", "server");
});

Package.on_test(function(api) {
  api.use(['underscore', "coffeescript", "spacejamio:munit", "spacejamio:cli"], 'server');
  api.add_files("tests/CLITest.coffee", "server")
});
