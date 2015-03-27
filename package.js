Npm.depends({
    'rc': '0.5.1'
});


Package.describe({
  summary: "A package and tools for creating and running command line / cli programs with meteor.",
  name: "practicalmeteor:mcli",
  version: "1.1.6",
  git: "https://github.com/practicalmeteor/meteor-mcli.git"
});


Package.onUse(function (api) {
  api.versionsFrom('0.9.3');

  api.use([
    "coffeescript",
    "underscore",
    "practicalmeteor:chai@1.9.2_3",
    "practicalmeteor:loglevel@1.2.0_1",
    'practicalmeteor:underscore.string@2.3.3_3'
  ], "server");

  api.addFiles(["src/log.js"], 'server');
  api.addFiles(["src/MeteorNoops.coffee"], 'server');
  api.add_files("src/CLI.coffee", "server");

  api.export("CLI", "server");
});


Package.onTest(function(api) {
  api.use(["coffeescript", "practicalmeteor:mcli", "practicalmeteor:loglevel@1.2.0_1", "practicalmeteor:munit@2.1.2"], 'server');
  api.add_files("tests/CLITest.coffee", "server")
});
