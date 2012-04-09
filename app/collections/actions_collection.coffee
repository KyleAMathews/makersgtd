Action = require('models/action_model').Action
FuzzyMatcherIntegration = require('mixins/collections/fuzzy_matcher_integration').FuzzyMatcherIntegration
DoneOrNot = require('mixins/collections/done_or_not').DoneOrNot
RemoveWhenDeleted = require('mixins/collections/remove_when_deleted').RemoveWhenDeleted

class exports.Actions extends Backbone.Collection

  model: Action
  url: '/actions'

  initialize: ->
    @type = "actions"
    @on('change:deleted', @removeWhenDeleted)

  remaining: ->
    @without.apply @, @done()

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

# Add Mixins
exports.Actions.prototype = _.extend exports.Actions.prototype,
  FuzzyMatcherIntegration, DoneOrNot, RemoveWhenDeleted
