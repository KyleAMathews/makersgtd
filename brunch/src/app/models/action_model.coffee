class exports.Action extends Backbone.Model

  defaults:
    name: 'empty action...'
    done: false
    order: 100

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
