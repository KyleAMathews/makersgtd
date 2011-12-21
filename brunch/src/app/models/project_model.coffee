ModelLinker = require('mixins/models/model_linker').ModelLinker
ToggleDoneness = require('mixins/models/toggle_doneness').ToggleDoneness
GetHtml = require('mixins/models/get_html').GetHtml

class exports.Project extends Backbone.Model

  defaults:
    name: 'empty project...'
    done: false
    type: 'project'
    project_links_limit: 1
    tag_links_limit: 0
    project_links: []
    tag_links: []

  initialize: ->

  clear: ->
    @view.remove()

# Add Mixins
exports.Project.prototype = _.extend exports.Project.prototype,
  ModelLinker, ToggleDoneness, GetHtml
