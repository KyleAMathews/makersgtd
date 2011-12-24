projectTemplate = require('templates/project_full')
editableView = require('views/editable_view').EditableView
linkerView = require('views/linker_view').LinkerView
actionsView = require('views/actions_view').ActionsView
SubActions = require('collections/sub_actions_collection').SubActions
MetaInfoView = require('views/meta_info').MetaInfoView
AddNewModelView = require('views/add_new_model_view').AddNewModelView

class exports.ProjectFullView extends Backbone.View

  className: 'full-view'
  id: 'projects'

  initialize: ->
    @model.view = @
    @model.bind("change:action_links", @renderActions)

  render: =>
    json = @model.toJSON()
    @$(@el).html(projectTemplate(project: json))
    editableName = new editableView(
      field: 'name'
      el: @$('.editable-name')
      prefix: '#'
      model: @model
      options: ['save-on-enter']
      blank_slate_text: 'Add Name'
    )
    if @model.get('done') then editableName.options.options.push 'done'
    editableName.render()
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
    newAction = new AddNewModelView(
      el: @$('.add-new-action')
      type: 'action'
      links: [
        {
          type: 'project'
          id: @model.id
        }
      ]
    ).render()
    new MetaInfoView(
      el: @$('.meta-info')
      model: @model
    ).render()
    @renderActions()
    @

  # TODO add completed actions
  renderActions: =>
    # Render the project's actions.
    subActions = new SubActions()
    ids = @model.get("action_links")
    actions = []
    if ids?
      actions = (app.util.getModel('action', id.id) for id in ids)

    subActions.reset(actions)

    new actionsView(
      el: @$('#actions-view')
      collection: subActions
      label: 'Actions'
    ).render()
    @

