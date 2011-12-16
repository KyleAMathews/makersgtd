ModelLinker = require('views/linker_view').ModelLinker

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

  toggle: ->
    @save(done: not @get 'done')

  clear: ->
    @destroy()
    @view.remove()

  # Internal URL
  iurl: =>
    return "#actions/" + @id
