class exports.Project extends Backbone.Model

  defaults:
    name: 'empty project...'
    done: false

  toggle: ->
    @save(done: not @get 'done')

  clear: ->
    @destroy()
    @view.remove()
