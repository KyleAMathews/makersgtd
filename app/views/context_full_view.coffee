contextTemplate = require('templates/context_full')
EditableView = require('views/editable_view').EditableView
ActionsView = require('views/actions_view').ActionsView
SubCollection = require('collections/sub_collection').SubCollection
DoneActionsView = require('views/done_actions_view').DoneActionsView
ProjectsView = require('views/projects_view').ProjectsView
DoneProjectsView = require('views/done_projects_view').DoneProjectsView
AddNewModelView = require('views/add_new_model_view').AddNewModelView
MetaInfoView = require('views/meta_info').MetaInfoView
DropdownMenuView = require('views/dropdown_menu_view').DropdownMenuView

class exports.ContextFullView extends Backbone.View

  id: 'context'
  className: 'full-view'

  initialize: ->
    @model.view = @

  render: =>
    json = @model.toJSON()
    @$el.html(contextTemplate(context: json))

    @logChildView new EditableView(
      field: 'name'
      el: @$('.editable-name')
      model: @model
      prefix: '@'
      options: ['save-on-enter']
      blank_slate_text: 'Add Name'
    ).render()
    @logChildView new EditableView(
      field: 'description'
      el: @$('.editable-note')
      model: @model
      lines: 3
      blank_slate_text: 'Add Notes'
      label: 'Notes'
      html: true
    ).render()
    @logChildView new DropdownMenuView(
      el: @$('.dropdown')
      model: @model
    ).render()

    # Render the context's loose actions, i.e. those without a project.
    doneFilter = (action) ->
      if action?.get('project_links')?.length > 0
        return false
      else
        return true

    contextActions = new SubCollection null,
      linkedModel: @model
      link_name: 'action_links'
      link_type: 'action'
      filter: doneFilter

    @logChildView new ActionsView(
      el: @$('#context-actions')
      collection: contextActions
      label: 'Actions'
    ).render()

    # Render the contexts's projects.
    subProjects = new SubCollection null,
      linkedModel: @model
      link_name: 'project_links'
      link_type: 'project'

    @logChildView new ProjectsView(
      el: @$('#projects-view')
      collection: subProjects
      label: 'Projects'
      actions: true
      context: @model.id
    ).render()
    @logChildView new DoneProjectsView(
      el: @$('#done-projects-view')
      collection: subProjects
      label: 'Completed Projects'
    ).render()
    @logChildView new AddNewModelView(
      el: @$('.context-add-new-action')
      type: 'action'
      links: [
        {
          type: 'context'
          id: @model.id
        }
      ]
    ).render()
    @logChildView new AddNewModelView(
      el: @$('.context-add-new-project')
      type: 'project'
      links: [
        {
          type: 'context'
          id: @model.id
        }
      ]
    ).render()
    @logChildView new MetaInfoView(
      el: @$('.meta-info')
      model: @model
    ).render()
    @
