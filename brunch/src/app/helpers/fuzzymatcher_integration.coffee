resetFuzzymatcher = (collection) ->
  fuzzymatcher.addList(collection.type, collection.toJSON())

$ ->
  # Defer so collections can be created first.
  _.defer ->
    events = ['add', 'remove', 'reset', 'change:done', 'change:name', 'change:deleted']
    for event in events
      app.collections.actions.on(event, resetFuzzymatcher)
      app.collections.projects.on(event, resetFuzzymatcher)
      app.collections.tags.on(event, resetFuzzymatcher)
