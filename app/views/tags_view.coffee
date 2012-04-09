TagView = require('views/tag_view').TagView
tagsTemplate = require('templates/tags')
AddNewModelView = require('views/add_new_model_view').AddNewModelView

class exports.TagsView extends Backbone.View

  className: 'collection-view'
  id: 'tags-view'

  initialize: ->
    @bindTo(@collection, 'add', @addOne)
    @bindTo(@collection, 'reset', @addAll)

  render: ->
    $(@el).html tagsTemplate()
    @addAll()
    @logChildView new AddNewModelView(
      el: @$('.add-new-tag')
      type: 'tag'
    ).render()
    @

  addOne: (tag) =>
    @logChildView view = new TagView model: tag
    $("#tags", @el).append view.render().el

  addAll: =>
    @$('#tags').empty()
    app.collections.tags.each @addOne
