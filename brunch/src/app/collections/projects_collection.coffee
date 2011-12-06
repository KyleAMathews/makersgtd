Project = require('models/project_model').Project

class exports.Projects extends Backbone.Collection

  model: Project
  url: '/projects'

  initialize: ->
    # Tie collection our fuzzymatcher quicksearch.
    @addToFuzzymatcher()
    @bind('reset', @addToFuzzymatcher)
    @bind('add', @addToFuzzymatcher)
    @bind('remove', @addToFuzzymatcher)
    @bind('change:name', @addToFuzzymatcher)

  done: ->
    items = @filter( (action) ->
      action.get 'done'
    )
    # return _.sortBy(items, (item) -> return item.get('order'))
    return items

  notDone: ->
    items = @filter( (action) ->
      not action.get 'done'
    )
    # return _.sortBy(items, (item) -> return item.get('order'))
    return items

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

  # Add all the current objects as a list in the Fuzzymatcher library.
  addToFuzzymatcher: =>
    fuzzymatcher.addList('projects', @toJSON())

  # Query model names using the Fuzzymatcher library.
  query: (query) =>
    return fuzzymatcher.query('projects', query)
