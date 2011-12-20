Project = require('models/project_model').Project
FuzzyMatcherIntegration = require('mixins/fuzzy_matcher_integration').FuzzyMatcherIntegration

class exports.Projects extends Backbone.Collection

  model: Project
  url: '/projects'

  initialize: ->
    @type = 'projects'

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

$(document).ready ->
  app.util.include exports.Projects, FuzzyMatcherIntegration
