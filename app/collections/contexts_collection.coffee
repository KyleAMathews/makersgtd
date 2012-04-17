Context = require('models/context_model').Context
FuzzyMatcherIntegration = require('mixins/collections/fuzzy_matcher_integration').FuzzyMatcherIntegration
RemoveWhenDeleted = require('mixins/collections/remove_when_deleted').RemoveWhenDeleted

class exports.Contexts extends Backbone.Collection

  model: Context
  url: '/contexts'

  initialize: ->
    @type = 'context'
    @on('change:deleted', @removeWhenDeleted)

  comparator: (context) ->
    context.get('name').toLowerCase()

# Add Mixins
exports.Contexts.prototype = _.extend exports.Contexts.prototype,
  FuzzyMatcherIntegration, RemoveWhenDeleted
