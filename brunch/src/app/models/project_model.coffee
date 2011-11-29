class exports.Project extends Backbone.Model

  defaults:
    name: 'empty project...'
    done: false

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
