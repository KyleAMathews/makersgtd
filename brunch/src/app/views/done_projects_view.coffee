ProjectView = require('views/project_view').ProjectView
projectsTemplate = require('templates/projects')

class exports.DoneProjectsView extends Backbone.View

  className: 'collection-view'
  id: 'done-projects-view'

  initialize: ->
    app.collections.projects.bind 'reset', @addAll
    app.collections.projects.bind 'change:done', @changeDoneState

  render: ->
    $(@el).html projectsTemplate()
    @addAll()
    # Remove the last border.
    @$('li:last').css('border-color', 'rgba(0,0,0,0)')
    @

  addOne: (project) =>
    view = new ProjectView model: project
    $(@el).find("#projects").append view.render().el

  addAll: =>
    @$('#projects').empty()
    projects = app.collections.projects.done()
    projects = _.sortBy projects, (project) -> project.get('completed')
    projects.reverse()
    @addOne project for project in projects
