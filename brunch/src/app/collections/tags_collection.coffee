Tag = require('models/tag_model').Tag

class exports.Tags extends Backbone.Collection

  model: Tag
  url: '/tags'

  initialize: ->
    console.log 'initing tag collection'

  comparator: (tag) ->
    tag.get 'name'
