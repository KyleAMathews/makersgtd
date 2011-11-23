TagView = require('views/tag_view').TagView
tagsTemplate = require('templates/tags')

class exports.TagsView extends Backbone.View

  id: 'tags-view'

  initialize: ->
    app.collections.tags.bind 'add', @addOne
    app.collections.tags.bind 'reset', @addAll

  render: ->
    $(@el).html tagsTemplate()
    @addAll()
    @

  addOne: (tag) =>
    view = new TagView model: tag
    $("#tags", @el).append view.render().el

  addAll: =>
    @$('#tags').empty()
    app.collections.tags.each @addOne
