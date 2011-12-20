ModelLinker = require('mixins/models/model_linker').ModelLinker
ToggleDoneness = require('mixins/models/toggle_doneness').ToggleDoneness

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

  # TODO refactor stuff like this into a model mixin class (?) that gets added to each
  # model. Same with collections.
  getHtml: (property) =>
    if @get(property)?
      html = markdown.makeHtml(@get(property))
      return html
    else
      return ''

  clear: ->
    @view.remove()

  # Internal URL
  iurl: =>
    return "#actions/" + @id

  delete: =>
    @save deleted: true
    @clear()

# Add Mixins
$(document).ready ->
  app.util.include exports.Action, ModelLinker
  app.util.include exports.Action, ToggleDoneness
