Npm.depends({
    'rc': '0.4.0'
});

Package.describe({
  summary: "Package for creating cli programs with meteor"
});

Package.on_use(function (api, where) {
  api.use(["coffeescript","chai","sinon"], "server");

  api.add_files("CLI.coffee", "server");
});

Package.on_test(function(api) {
  api.use(['underscore', "coffeescript", "chai", "sinon", "munit", "meteor-cli"]);
  api.add_files("tests/CLITest.coffee", "server")
});
