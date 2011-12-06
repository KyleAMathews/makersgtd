actionTemplate = require('templates/action_full')
linkerTemplate = require('templates/linker')
editableView = require('views/editable_view').EditableView

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

    # Make sure HTML is finished being inserted.
    callback = -> $('.expanding-area').makeExpandingArea()
    setTimeout callback, 0
    @

    # TODO convert other editable views.
    # Start on linker widget.
