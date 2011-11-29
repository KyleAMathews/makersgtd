class exports.Tag extends Backbone.Model

  defaults:
    name: 'tagname'

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
