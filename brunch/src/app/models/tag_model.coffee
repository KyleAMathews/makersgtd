ModelLinker = require('views/linker_view').ModelLinker

class exports.Tag extends Backbone.Model

  defaults:
    name: 'tagname'
    type: 'tag'
    project_links_limit: 0
    action_links_limit: 0
    project_links: []
    action_links: []

  initialize: ->
    # Add the linker class to enable this model to create links to other models.
    @linker = new ModelLinker(@)

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
    return "#tags/" + @id
