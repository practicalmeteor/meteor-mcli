Npm.depends({
    'rc':'0.4.0'
});

Package.describe({
    summary: "Meteor cli"
});

Package.on_use(function (api, where) {
    api.use(["coffeescript","chai","sinon"]);
    api.add_files("CLI.coffee", "server");
    api.add_files("main.coffee", "server");
});

Package.on_test(function(api) {
    api.use(["coffeescript","chai","munit", "sinon", "meteor-cli"]);
    api.add_files("tests/CLITest.coffee", "server")
});

