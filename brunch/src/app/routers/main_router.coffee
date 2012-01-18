ActionFullView = require('views/action_full_view').ActionFullView
ProjectFullView = require('views/project_full_view').ProjectFullView
TagFullView = require('views/tag_full_view').TagFullView
AddNewModelView = require('views/add_new_model_view').AddNewModelView

# Actions
ActionsView = require('views/actions_view').ActionsView
DoneActionsView = require('views/done_actions_view').DoneActionsView

# Projects
ProjectsView = require('views/projects_view').ProjectsView
DoneProjectsView = require('views/done_projects_view').DoneProjectsView

# Tags
TagsView = require('views/tags_view').TagsView

class exports.MainRouter extends Backbone.Router
  routes :
    "next-actions": "nextActions"
    "projects": "projects"
    "tags": "tags"
    "actions/:id": "actionView"
    "projects/:id": "projectView"
    "tags/:id": "tagView"

  nextActions: ->
    actions = new ActionsView(
      collection: app.collections.actions
      addNewModelForm: 1
    )

    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.next-actions').addClass('active')

    $('#simple-gtd-app h1.title').html 'Next Actions'
    app.pane0.show(actions)

  projects: ->
    projects = new ProjectsView(
      collection: app.collections.projects
      addNewModelForm: 1
    )
    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.projects').addClass('active')

    $('#simple-gtd-app h1.title').html 'Projects'
    app.pane0.show(projects)

  tags: ->
    tags = new TagsView(
      collection: app.collections.tags
    )

    $('nav li a.active').removeClass('active')
    $('nav li a.tags').addClass('active')

    $('#simple-gtd-app h1.title').html 'Filters'
    app.pane0.show(tags)

  actionView: (id) ->
    app.util.loadModel 'action', id, (action) ->
      $('#simple-gtd-app h1.title').html 'Action'

      # TODO this stuff should be in a view and it be listening to something...
      # but not too important as it'll all disappear at some point.
      $('nav li a.active').removeClass('active')
      $('nav li a.next-actions').addClass('active')

      if action?
        actionFullView = new ActionFullView model: action
        app.pane0.show(actionFullView)

  projectView: (id) ->
    app.util.loadModel 'project', id, (project) ->
      $('#simple-gtd-app h1.title').html 'Project'

      $('nav li a.active').removeClass('active')
      $('nav li a.projects').addClass('active')

      if project?
        projectFullView = new ProjectFullView model: project
        app.pane0.show(projectFullView)

  tagView: (id) ->
    app.util.loadModel 'tag', id, (tag) ->
      $('#simple-gtd-app h1.title').html 'Tag'

      $('nav li a.active').removeClass('active')
      $('nav li a.tags').addClass('active')

      if tag?
        tagView = new TagFullView model: tag
        app.pane0.show(tagView)
