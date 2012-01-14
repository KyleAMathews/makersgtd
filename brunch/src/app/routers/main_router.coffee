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
    actions = new ActionsView( collection: app.collections.actions )
    doneActions = new DoneActionsView( collection: app.collections.actions )
    newAction = new AddNewModelView(
      type: 'action'
    )

    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.next-actions').addClass('active')

    $('#simple-gtd-app h1.title').html 'Next Actions'
    $('#simple-gtd-app .content').append actions.render().el
    $('#simple-gtd-app .content').append newAction.render().el
    $('#simple-gtd-app .content').append doneActions.render().el

  projects: ->
    projects = new ProjectsView( collection: app.collections.projects )
    doneProjects = new DoneProjectsView(
      collection: app.collections.projects
      label: 'Completed projects'
    )
    newProject = new AddNewModelView(
      type: 'project'
    )
    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.projects').addClass('active')

    $('#simple-gtd-app h1.title').html 'Projects'
    $('#simple-gtd-app .content').append projects.render().el
    $('#simple-gtd-app .content').append newProject.render().el
    $('#simple-gtd-app .content').append doneProjects.render().el

  tags: ->
    tags = new TagsView()
    newTag = new AddNewModelView(
      type: 'tag'
    )
    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.tags').addClass('active')

    $('#simple-gtd-app h1.title').html 'Filters'
    $('#simple-gtd-app .content').append tags.render().el
    $('#simple-gtd-app .content').append newTag.render().el

  actionView: (id) ->
    action = app.util.loadModel('action', id)
    $('#simple-gtd-app h1.title').html 'Action'

    $('nav li a.active').removeClass('active')
    $('nav li a.next-actions').addClass('active')

    if action?
      actionFullView = new ActionFullView model: action
      $('#simple-gtd-app .content').html actionFullView.render().el

  projectView: (id) ->
    project = app.util.loadModel('project', id)

    $('#simple-gtd-app h1.title').html 'Project'

    $('nav li a.active').removeClass('active')
    $('nav li a.projects').addClass('active')

    if project?
      projectFullView = new ProjectFullView model: project
      $('#simple-gtd-app .content').html projectFullView.render().el

  tagView: (id) ->
    tag = app.util.loadModel('tag', id)

    $('#simple-gtd-app h1.title').html 'Tag'

    $('nav li a.active').removeClass('active')
    $('nav li a.tags').addClass('active')

    if tag?
      tagView = new TagFullView model: tag
      $('#simple-gtd-app .content').html tagView.render().el
