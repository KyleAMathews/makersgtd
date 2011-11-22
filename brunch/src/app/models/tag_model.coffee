class exports.Tag extends Backbone.Model

  defaults:
    name: 'tagname'

  clear: ->
    @destroy()
    @view.remove()
