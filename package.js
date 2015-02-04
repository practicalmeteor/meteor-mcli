Npm.depends({
    'rc': '0.5.1'
});


Package.describe({
  summary: "A package and tools for creating and running command line / cli programs with meteor.",
  name: "practicalmeteor:mcli",
  version: "1.1.5",
  git: "https://github.com/practicalmeteor/meteor-mcli.git"
});


Package.onUse(function (api) {
  api.versionsFrom('0.9.3');

  // So that in functional tests webapp will be loaded before us, and we don't define main,
  // since webapp has already defined a main
  api.use('webapp', 'server', {weak: true});

  api.use([
    "coffeescript",
    "underscore",
    "practicalmeteor:chai@1.9.2_3",
    "practicalmeteor:loglevel@1.1.0_3",
    'practicalmeteor:underscore.string@2.3.3_3'
  ], "server");

  api.addFiles(["src/log.js"], 'server');
  api.addFiles(["src/MeteorNoops.coffee"], 'server');
  api.addFiles("src/CLI.coffee", "server");

  api.export("CLI", "server");

  if( ! process.env.METEOR_TEST_PACKAGES ) {
    api.addFiles('src/main.js', 'server');

    api.export("main", "server");
  }
});


Package.onTest(function(api) {
  api.use(["coffeescript", "practicalmeteor:mcli", "practicalmeteor:loglevel@1.1.0_3", "practicalmeteor:munit@2.1.2"], 'server');

  api.addFiles("tests/CLITest.coffee", "server")
});
