exports.FuzzyMatcherIntegration =
  # Query model names using the Fuzzymatcher library.
  query: (query) ->
    return fuzzymatcher.query(@type, query)
