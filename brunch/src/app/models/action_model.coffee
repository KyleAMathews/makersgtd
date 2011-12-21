ModelLinker = require('mixins/models/model_linker').ModelLinker
ToggleDoneness = require('mixins/models/toggle_doneness').ToggleDoneness
GetHtml = require('mixins/models/get_html').GetHtml

class exports.Action extends Backbone.Model

  defaults:
    name: 'empty action...'
    done: false
    order: 100
    type: 'action'
    project_links_limit: 1
    tag_links_limit: 0
    project_links: []
    tag_links: []

  initialize: ->

  clear: ->
    @view.remove()

  delete: =>
    @save deleted: true
    @clear()

# Add Mixins
exports.Action.prototype = _.extend exports.Action.prototype,
  ModelLinker, ToggleDoneness, GetHtml
