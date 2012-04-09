projectTemplate = require('templates/project_full')
editableView = require('views/editable_view').EditableView
linkerView = require('views/linker_view').LinkerView
DoneActionsView = require('views/done_actions_view').DoneActionsView
actionsView = require('views/actions_view').ActionsView
SubCollection = require('collections/sub_collection').SubCollection
MetaInfoView = require('views/meta_info').MetaInfoView
AddNewModelView = require('views/add_new_model_view').AddNewModelView
DropdownMenuView = require('views/dropdown_menu_view').DropdownMenuView

class exports.ProjectFullView extends Backbone.View

  className: 'full-view'
  id: 'project'

  initialize: ->
    @model.view = @
    @bindTo(@model, 'change:done', @render)

  render: =>
    json = @model.toJSON()
    @$el.html(projectTemplate(project: json))
    @logChildView editableName = new editableView(
      field: 'name'
      el: @$('.editable-name')
      prefix: '#'
      model: @model
      options: ['save-on-enter']
      blank_slate_text: 'Add Name'
    )
    if @model.get('done') then editableName.options.options.push 'done'
    editableName.render()
    @logChildView editableName
    @logChildView new editableView(
      field: 'outcome_vision'
      el: @$('.editable-outcome-vision')
      model: @model
      lines: 3
      blank_slate_text: 'Add Outcome Vision'
      label: 'Outcome Vision'
      html: true
    ).render()
    @logChildView new editableView(
      field: 'description'
      el: @$('.editable-note')
      model: @model
      lines: 3
      blank_slate_text: 'Add Notes'
      label: 'Notes'
      html: true
    ).render()
    @logChildView new linkerView(
      el: @$('.linker-tag')
      model: @model
      blank_slate: 'Add a tag'
      linking_to: 'tag'
      intro: 'tagged with '
      prefix: '@'
      models: @model.get('tags')
    ).render()
    @logChildView new DropdownMenuView(
      el: @$('.dropdown')
      model: @model
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
    )
    # New actions should also inherit their parent project's tags.
    for tag in @model.get('tag_links')
      newAction.options.links.push tag
    newAction.render()
    @logChildView newAction
    @logChildView new MetaInfoView(
      el: @$('.meta-info')
      model: @model
    ).render()
    @renderActions()
    @

  renderActions: =>
    # Render the project's actions.
    subActions = new SubCollection null,
      linkedModel: @model
      link_name: 'action_links'
      link_type: 'action'

    @logChildView new actionsView(
      el: @$('#actions-view')
      collection: subActions
      label: 'Actions'
    ).render()
    @logChildView new DoneActionsView(
      el: @$('#done-actions-view')
      collection: subActions
      label: 'Completed Actions'
    ).render()
    @
