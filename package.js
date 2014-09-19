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
  api.use(["coffeescript","spacejamio:chai@0.1.6"], "server");

  api.add_files("CLI.coffee", "server");
});

Package.on_test(function(api) {
  api.use(['underscore', "coffeescript", "spacejamio:chai@0.1.6", "spacejamio:sinon@0.1.6", "spacejamio:munit@0.2.1", "meteor-cli"]);
  api.add_files("tests/CLITest.coffee", "server")
});
