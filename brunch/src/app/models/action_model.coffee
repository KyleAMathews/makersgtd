class exports.Action extends Backbone.Model

  defaults:
    name: 'empty action...'
    done: false
    order: 100

  toggle: ->
    @save(done: not @get 'done')

  clear: ->
    @destroy()
    @view.remove()
