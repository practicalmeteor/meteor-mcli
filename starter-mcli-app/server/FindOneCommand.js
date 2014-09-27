// There is no need to provide default options, if none should be set, rc will provide all options anyway,
// but we like to specify them with null values, for command documentation purposes.

//var defaultOptions = {
//  collection: null
//};

var findOneCommand = function(options) {
  // We use the meteor logging package, instead of console.log and console.error
  if( ! options.collection )
    console.error('Error: --collection is missing.');

  if( ! global[options.collection] ) {
    console.error("Error: The collection" + options.collection + " doesn't exist.");
    return;
  }

  doc = global[options.collection].findOne();
  if(doc)
    console.info(JSON.stringify(doc, null, 2));
  else
    console.error('Error: No documents found in the ' + options.collection + ' collection.');
};

CLI.registerCommand('find-one', findOneCommand);
