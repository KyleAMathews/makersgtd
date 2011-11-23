ProjectView = require('views/project_view').ProjectView
projectsTemplate = require('templates/projects')

class exports.ProjectsView extends Backbone.View

  id: 'projects-view'

  initialize: ->
    app.collections.projects.bind 'add', @addOne
    app.collections.projects.bind 'reset', @addAll

  render: ->
    $(@el).html projectsTemplate()
    @addAll()
    @

  addOne: (project) =>
    view = new ProjectView model: project
    $("#projects", @el).append view.render().el

  addAll: =>
    @$('#projects').empty()
    @addOne project for project in app.collections.projects.notDone()
