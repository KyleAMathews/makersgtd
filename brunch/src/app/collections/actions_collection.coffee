Action = require('models/action_model').Action
FuzzyMatcherIntegration = require('mixins/collections/fuzzy_matcher_integration').FuzzyMatcherIntegration
DoneOrNot = require('mixins/collections/done_or_not').DoneOrNot

class exports.Actions extends Backbone.Collection

  model: Action
  url: '/actions'

  initialize: ->
    @type = "actions"

    # Tie collection our fuzzymatcher quicksearch.
    @addToFuzzymatcher()
    @bind('reset', @addToFuzzymatcher)
    @bind('add', @addToFuzzymatcher)
    @bind('remove', @addToFuzzymatcher)
    @bind('change:name', @addToFuzzymatcher)

  remaining: ->
    @without.apply @, @done()

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

# Add Mixins
$(document).ready ->
  app.util.include exports.Actions, FuzzyMatcherIntegration
  app.util.include exports.Actions, DoneOrNot
