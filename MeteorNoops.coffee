if not Meteor.server
  # Meteor.server is not defined, creating noop implementations for all meteor ddp methods
  _.each(['publish', 'methods', 'call', 'apply', 'onConnection'],
  (name) ->
    Meteor[name] = ->
  );
