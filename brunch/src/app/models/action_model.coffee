class exports.Action extends Backbone.Model

  defaults:
    content: 'empty action...'
    done: false

  toggle: ->
    @save(done: not @get 'done')

  clear: ->
    @destroy()
    @view.remove()
