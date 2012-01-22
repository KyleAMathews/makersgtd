tagTemplate = require('templates/tag')
ProjectView = require('views/project_view').ProjectView

class exports.TagView extends Backbone.View

  className: 'tag-list-item'

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @bindTo(@model, 'change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = @model.iurl()
    @$(@el).html(tagTemplate(tag: json))
    # TODO change this to notDoneProjects.
    if @options.projects and @model.get('project_links').length > 0
      links = @model.get('project_links')
      for link in links
        project = app.util.loadModelSynchronous('project', link.id)
        if not project then continue
        # If actions are to be displayed, ensure the tag has some.
        # TODO keep track of which actions aren't part of a project and add them afterwards.
        if @options.actions and project.notDoneActions().length is 0 then continue
        @logChildView projectView = new ProjectView
          model: project
          actions: @options.actions
        @$('.projects').append projectView.render().el
    @
