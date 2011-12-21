Tag = require('models/tag_model').Tag
FuzzyMatcherIntegration = require('mixins/collections/fuzzy_matcher_integration').FuzzyMatcherIntegration

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

# Add Mixins
exports.Tags.prototype = _.extend exports.Tags.prototype,
  FuzzyMatcherIntegration
