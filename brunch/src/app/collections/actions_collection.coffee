Action = require('models/action_model').Action

class exports.Actions extends Backbone.Collection

  model: Action
  url: '/actions'

  initialize: ->
    @type = "actions"

    # Tie collection our fuzzymatcher quicksearch.
    @addToFuzzymatcher()
    @bind('reset', @addToFuzzymatcher)
    @bind('add', @addToFuzzymatcher)
    @bind('remove', @addToFuzzymatcher)
    @bind('change:name', @addToFuzzymatcher)

  done: ->
    items = @filter( (action) ->
      action.get 'done'
    )
    items = _.sortBy items, (item) -> return item.get('completed')
    return items

  notDone: ->
    items = @filter( (action) ->
      not action.get 'done'
    )
    items = _.sortBy items, (item) -> return item.get('order')
    return items

  remaining: ->
    @without.apply @, @done()

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

  # Add all the current objects as a list in the Fuzzymatcher library.
  addToFuzzymatcher: =>
    fuzzymatcher.addList('actions', @toJSON())

  # Query model names using the Fuzzymatcher library.
  query: (query) =>
    return fuzzymatcher.query('actions', query)
