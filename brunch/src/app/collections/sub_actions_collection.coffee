Action = require('models/action_model').Action

class exports.SubActions extends Backbone.Collection

  model: Action

  done: ->
    items = @filter (action) ->
      action.get 'done'
    items = _.sortBy items, (item) -> return item.get('completed')
    return items

  notDone: ->
    items = @filter (action) ->
      not action.get 'done'
    return items
