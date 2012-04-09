exports.DoneOrNot =
  done: ->
    items = @filter( (model) ->
      model.get 'done'
    )
    items = _.sortBy items, (item) -> return item.get('completed')
    return items

  notDone: ->
    items = @filter( (model) ->
      not model.get 'done'
    )
    items = _.sortBy items, (item) -> return item.get('order')
    return items
