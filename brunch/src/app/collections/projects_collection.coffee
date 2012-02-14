Project = require('models/project_model').Project
FuzzyMatcherIntegration = require('mixins/collections/fuzzy_matcher_integration').FuzzyMatcherIntegration
DoneOrNot = require('mixins/collections/done_or_not').DoneOrNot

class exports.Projects extends Backbone.Collection

  model: Project
  url: '/projects'

  initialize: ->
    @type = 'projects'

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

# Add Mixins
exports.Projects.prototype = _.extend exports.Projects.prototype,
  FuzzyMatcherIntegration, DoneOrNot
