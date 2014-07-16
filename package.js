Npm.depends({
    'rc':'0.4.0'
});

Package.describe({
    summary: "Meteor cli"
});

Package.on_use(function (api, where) {
    api.use(["coffeescript","chai","sinon"]);
    api.add_files("CLI.coffee", "server");
    api.add_files("main.js", "server");
    //api.export("CLI");
    //api.export("main");
});

Package.on_test(function(api) {
    api.use(["coffeescript","chai","munit", "meteor-cli"]);
    api.add_files("tests/CLITest.coffee", "server")
});

