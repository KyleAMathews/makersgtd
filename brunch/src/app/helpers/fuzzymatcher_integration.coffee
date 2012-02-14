resetFuzzymatcher = (arg1, arg2) ->
  if arg1 instanceof Backbone.Collection
    collection = arg1
  else if arg2 instanceof Backbone.Collection
    collection = arg2
  else if arg1.collection instanceof Backbone.Collection
    collection = arg1.collection
  else if arg2.collection instanceof Backbone.Collection
    collection = arg2.collection
  else
    return # This wasn't a collection.

  # Success
  fuzzymatcher.addList(collection.type, collection.toJSON())

# Prevent collections from being reset repeatedly on rapid events like adding
# models when a sub_collection loads.
actions_debounced = _.debounce(resetFuzzymatcher, 500)
projects_debounced = _.debounce(resetFuzzymatcher, 500)
tags_debounced = _.debounce(resetFuzzymatcher, 500)

$ ->
  # Defer so collections can be created first.
  _.defer ->
    events = ['add', 'remove', 'reset', 'change:done', 'change:name', 'change:deleted',
    'add:action_link', 'add:project_link', 'add_tag_link']
    for event in events
      app.collections.actions.on(event, actions_debounced)
      app.collections.projects.on(event, projects_debounced)
      app.collections.tags.on(event, tags_debounced)
