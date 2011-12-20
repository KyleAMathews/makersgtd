Tag = require('models/tag_model').Tag
FuzzyMatcherIntegration = require('mixins/fuzzy_matcher_integration').FuzzyMatcherIntegration

class exports.Tags extends Backbone.Collection

  model: Tag
  url: '/tags'

  initialize: ->
    @type = 'tags'

    # Tie collection our fuzzymatcher quicksearch.
    @addToFuzzymatcher()
    @bind('reset', @addToFuzzymatcher)
    @bind('add', @addToFuzzymatcher)
    @bind('remove', @addToFuzzymatcher)
    @bind('change:name', @addToFuzzymatcher)

  comparator: (tag) ->
    tag.get 'name'

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

$(document).ready ->
  app.util.include exports.Tags, FuzzyMatcherIntegration
