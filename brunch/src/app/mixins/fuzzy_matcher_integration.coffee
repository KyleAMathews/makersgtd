exports.FuzzyMatcherIntegration =
  # Add all the current objects as a list in the Fuzzymatcher library.
  addToFuzzymatcher: ->
    fuzzymatcher.addList(@.type, @.toJSON())

  # Query model names using the Fuzzymatcher library.
  query: (query) ->
    return fuzzymatcher.query(@.type, query)
