tagTemplate = require('templates/tag_full')
EditableView = require('views/editable_view').EditableView
ActionsView = require('views/actions_view').ActionsView
SubCollection = require('collections/sub_collection').SubCollection
DoneActionsView = require('views/done_actions_view').DoneActionsView
ProjectsView = require('views/projects_view').ProjectsView
SubProjects = require('collections/sub_projects_collection').SubProjects
DoneProjectsView = require('views/done_projects_view').DoneProjectsView
MetaInfoView = require('views/meta_info').MetaInfoView
DropdownMenuView = require('views/dropdown_menu_view').DropdownMenuView

class exports.TagFullView extends Backbone.View

  id: 'tags'
  className: 'full-view'

  initialize: ->
    # @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    @$(@el).html(tagTemplate(tag: json))

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
      el: @$('.editable-description')
      model: @model
      lines: 3
      blank_slate_text: 'Add Description'
      label: 'Description'
      html: true
    ).render()
    @logChildView new DropdownMenuView(
      el: @$('.dropdown')
      model: @model
    ).render()

    # Render the tag's actions.
    subActions = new SubCollection [],
      linkedModel: @model
      link_name: 'action_links'
      link_type: 'action'

    @logChildView new ActionsView(
      el: @$('#actions-view')
      collection: subActions
      label: 'Next Actions'
    ).render()
    @logChildView new DoneActionsView(
      el: @$('#done-actions-view')
      collection: subActions
      label: 'Completed Actions'
    ).render()

    # Render the tags's projects.
    subProjects = new SubCollection [],
      linkedModel: @model
      link_name: 'project_links'
      link_type: 'project'

    @logChildView new ProjectsView(
      el: @$('#projects-view')
      collection: subProjects
      label: 'Projects'
      tag: @model.id
    ).render()
    @logChildView new DoneProjectsView(
      el: @$('#done-projects-view')
      collection: subProjects
      label: 'Completed Projects'
    ).render()
    @logChildView new MetaInfoView(
      el: @$('.meta-info')
      model: @model
    ).render()
    @
