Tag = require('models/tag_model').Tag
FuzzyMatcherIntegration = require('mixins/collections/fuzzy_matcher_integration').FuzzyMatcherIntegration
RemoveWhenDeleted = require('mixins/collections/remove_when_deleted').RemoveWhenDeleted

class exports.Tags extends Backbone.Collection

  model: Tag
  url: '/tags'

  initialize: ->
    @type = 'tags'
    @on('change:deleted', @removeWhenDeleted)

  comparator: (tag) ->
    tag.get('name').toLowerCase()

# Add Mixins
exports.Tags.prototype = _.extend exports.Tags.prototype,
  FuzzyMatcherIntegration, RemoveWhenDeleted
