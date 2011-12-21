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
    @destroy()
    @view.remove()

# Add Mixins
$(document).ready ->
  app.util.include exports.Tag, ModelLinker
  app.util.include exports.Tag, GetHtml
