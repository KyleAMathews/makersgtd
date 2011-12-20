ModelLinker = require('mixins/models/model_linker').ModelLinker

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

  toggle: ->
    if @get 'done'
      @save({
        done: false
      }, { silent: true })
      @unset('completed')
      @trigger("change:done")
    else
      @save({
        done: true
        completed: new Date().toISOString()
      }, { silent: true })
      @trigger("change:done")

  clear: ->
    @destroy()
    @view.remove()

  # Internal URL
  iurl: =>
    return "#actions/" + @id

# Add Mixins
$(document).ready ->
  app.util.include exports.Action, ModelLinker
