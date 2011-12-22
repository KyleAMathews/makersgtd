tagTemplate = require('templates/tag_full')
EditableView = require('views/editable_view').EditableView
ActionsView = require('views/actions_view').ActionsView
SubActions = require('collections/sub_actions_collection').SubActions
DoneActionsView = require('views/done_actions_view').DoneActionsView
ProjectsView = require('views/projects_view').ProjectsView
SubProjects = require('collections/sub_projects_collection').SubProjects
DoneProjectsView = require('views/done_projects_view').DoneProjectsView
MetaInfoView = require('views/meta_info').MetaInfoView

class exports.TagFullView extends Backbone.View

  id: 'tags'
  className: 'full-view'

  initialize: ->
    # @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    @$(@el).html(tagTemplate(tag: json))

    new EditableView(
      field: 'name'
      el: @$('.editable-name')
      model: @model
      prefix: '@'
      options: ['save-on-enter']
      blank_slate_text: 'Add Name'
    ).render()
    new EditableView(
      field: 'description'
      el: @$('.editable-description')
      model: @model
      blank_slate_text: 'Add Description'
      label: 'Description'
      html: true
    ).render()

    # Render the tag's actions.
    subActions = new SubActions()
    ids = @model.get("action_links")
    actions = []
    if ids?
      actions = (app.util.getModel('action', id.id) for id in ids)

    subActions.reset(actions)

    new ActionsView(
      el: @$('#actions-view')
      collection: subActions
      label: 'Next Actions'
    ).render()
    new DoneActionsView(
      el: @$('#done-actions-view')
      collection: subActions
      label: 'Completed Actions'
    ).render()

    # Render the tags's projects.
    subProjects = new SubProjects()
    ids = @model.get("project_links")
    projects = []
    if ids?
      projects = (app.util.getModel('project', id.id) for id in ids)

    subProjects.reset(projects)

    new ProjectsView(
      el: @$('#projects-view')
      collection: subProjects
      label: 'Projects'
    ).render()
    new DoneProjectsView(
      el: @$('#done-projects-view')
      collection: subProjects
      label: 'Completed Projects'
    ).render()
    new MetaInfoView(
      el: @$('.meta-info')
      model: @model
    ).render()
    @
