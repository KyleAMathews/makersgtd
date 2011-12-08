actionTemplate = require('templates/action_full')
linkerTemplate = require('templates/linker')
editableView = require('views/editable_view').EditableView
linkerView = require('views/linker_view').LinkerView

class exports.ActionFullView extends Backbone.View

  id: 'actions'
  className: 'full-view'

  initialize: ->
    # @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    @$(@el).html(actionTemplate(
      action: json
      linkerTemplate: linkerTemplate
    ))
    new editableView(
      field: 'name'
      el: @$('.editable-name')
      model: @model
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

    new linkerView(
      el: @$('.linker-project')
      model: @model
      blank_slate: 'Add to project'
      type: 'project'
      collection: 'projects'
      limit: 1
      intro: 'in project '
      prefix: '#'
      models: @model.get('projects')
    ).render()
    new linkerView(
      el: @$('.linker-tag')
      model: @model
      blank_slate: 'Add a tag'
      type: 'tag'
      collection: 'tags'
      intro: 'tagged with '
      prefix: '@'
      models: @model.get('tags')
    ).render()
    @
