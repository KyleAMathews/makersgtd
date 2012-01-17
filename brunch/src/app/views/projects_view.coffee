ProjectView = require('views/project_view').ProjectView
projectsTemplate = require('templates/projects')

class exports.ProjectsView extends Backbone.View

  className: 'collection-view'
  id: 'projects-view'

  initialize: ->
    @bindTo @collection, 'add', @addOne
    @bindTo @collection, 'reset', @addAll

  render: ->
    $(@el).html projectsTemplate()
    # Return if there's no projects to render.
    if @collection.notDone().length is 0 then return @
    @addAll()
    if @options.label?
      $(@el).prepend('<h4>' + @options.label + '</h4>')
    # Remove the last border.
    @$('li:last').css('border-color', 'rgba(0,0,0,0)')
    # TODO add completed projects
    @

  addOne: (project) =>
    view = new ProjectView model: project
    $("#projects", @el).append view.render().el

  addAll: =>
    @$('#projects').empty()
    @addOne project for project in @collection.notDone()
