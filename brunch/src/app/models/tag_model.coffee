ModelLinker = require('mixins/models/model_linker').ModelLinker
GetHtml = require('mixins/models/get_html').GetHtml

class exports.Tag extends Backbone.Model

  defaults:
    name: 'tagname'
    type: 'tag'
    project_links_limit: 0
    action_links_limit: 0
    project_links: []
    action_links: []

  initialize: ->

  clear: ->
    @view.remove()

# Add Mixins
exports.Tag.prototype = _.extend exports.Tag.prototype,
  ModelLinker, GetHtml
