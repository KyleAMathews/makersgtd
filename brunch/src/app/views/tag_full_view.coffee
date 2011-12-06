tagTemplate = require('templates/tag_full')
editableView = require('views/editable_view').EditableView

class exports.TagFullView extends Backbone.View

  id: 'tags'
  className: 'full-view'

  initialize: ->
    # @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    @$(@el).html(tagTemplate(tag: json))

    new editableView(
      field: 'name'
      el: @$('.editable-name')
      model: @model
      prefix: '@'
      options: ['save-on-enter']
      blank_slate_text: 'Add Name'
    ).render()
    new editableView(
      field: 'description'
      el: @$('.editable-description')
      model: @model
      blank_slate_text: 'Add Description'
      label: 'Description'
      html: true
    ).render()
    @
