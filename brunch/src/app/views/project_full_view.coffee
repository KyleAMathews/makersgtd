projectTemplate = require('templates/project_full')
editableView = require('views/editable_view').EditableView
linkerView = require('views/linker_view').LinkerView

class exports.ProjectFullView extends Backbone.View

  className: 'full-view'
  id: 'projects'

  initialize: ->
    @model.view = @

  render: =>
    json = @model.toJSON()
    @$(@el).html(projectTemplate(project: json))
    new editableView(
      field: 'name'
      el: @$('.editable-name')
      prefix: '#'
      model: @model
      options: ['save-on-enter']
      blank_slate_text: 'Add Name'
    ).render()
    new editableView(
      field: 'outcome_vision'
      el: @$('.editable-outcome-vision')
      model: @model
      blank_slate_text: 'Add Outcome Vision'
      label: 'Outcome Vision'
      html: true
    ).render()
    new editableView(
      field: 'description'
      el: @$('.editable-description')
      model: @model
      blank_slate_text: 'Add Description'
      label: 'Description'
      html: true
    ).render()
    new linkerView(
      el: @$('.linker-tag')
      model: @model
      blank_slate: 'Add a tag'
      linking_to: 'tag'
      intro: 'tagged with '
      prefix: '@'
      models: @model.get('tags')
    ).render()
    @

