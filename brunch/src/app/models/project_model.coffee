ModelLinker = require('mixins/models/model_linker').ModelLinker
ToggleDoneness = require('mixins/models/toggle_doneness').ToggleDoneness

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

  # TODO refactor stuff like this into a model mixin class (?) that gets added to each
  # model. Same with collections.
  getHtml: (property) =>
    if @get(property)?
      html = markdown.makeHtml(@get(property))
      return html
    else
      return ''

  clear: ->
    @destroy()
    @view.remove()

  # Internal URL
  iurl: =>
    return "#projects/" + @id

# Add Mixins
$(document).ready ->
  app.util.include exports.Project, ModelLinker
  app.util.include exports.Project, ToggleDoneness
