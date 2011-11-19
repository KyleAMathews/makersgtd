Action = require('models/action_model').Action

class exports.Actions extends Backbone.Collection

  model: Action

  initialize: ->
    @localStorage = new Store "actions"

  done: ->
    return @filter( (action) ->
      action.get 'done'
    )

  remaining: ->
    @without.apply @, @done()

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

  comparator: (action) ->
    action.get 'order'

  clearCompleted: ->
    _.each(@done(), (action) ->
      action.clear()
    )
