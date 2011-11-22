class exports.Action extends Backbone.Model

  defaults:
    name: 'empty action...'
    done: false

  toggle: ->
    @save(done: not @get 'done')

  clear: ->
    @destroy()
    @view.remove()
