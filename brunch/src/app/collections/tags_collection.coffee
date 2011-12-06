Tag = require('models/tag_model').Tag

class exports.Tags extends Backbone.Collection

  model: Tag
  url: '/tags'

  initialize: ->
    # Tie collection our fuzzymatcher quicksearch.
    @addToFuzzymatcher()
    @bind('reset', @addToFuzzymatcher)
    @bind('add', @addToFuzzymatcher)
    @bind('remove', @addToFuzzymatcher)
    @bind('change:name', @addToFuzzymatcher)

  comparator: (tag) ->
    tag.get 'name'

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

  # Add all the current objects as a list in the Fuzzymatcher library.
  addToFuzzymatcher: =>
    fuzzymatcher.addList('tags', @toJSON())

  # Query model names using the Fuzzymatcher library.
  query: (query) =>
    return fuzzymatcher.query('tags', query)
