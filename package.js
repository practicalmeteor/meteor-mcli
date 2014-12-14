Npm.depends({
    'rc': '0.5.1'
});


Package.describe({
  summary: "This package has been renamed to practicalmeteor:mcli. Please use the new name instead.",
  name: "spacejamio:mcli",
  version: "1.1.2",
  git: "https://github.com/practicalmeteor/meteor-mcli.git"
});


Package.onUse(function (api) {
  api.versionsFrom('0.9.3');

  api.use([
    "coffeescript",
    "underscore",
    "practicalmeteor:chai@1.9.2_3",
    "practicalmeteor:loglevel@1.1.0_3"
  ], "server");

  api.addFiles(["src/log.js"], 'server');
  api.addFiles(["src/MeteorNoops.coffee"], 'server');
  api.add_files("src/CLI.coffee", "server");

  api.export("CLI", "server");
});


Package.onTest(function(api) {
  api.use(["coffeescript", "spacejamio:mcli", "practicalmeteor:munit@2.1.2"], 'server');
  api.add_files("tests/CLITest.coffee", "server")
});
