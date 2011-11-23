newProjectTemplate = require('templates/new_project')

class exports.NewProjectView extends Backbone.View

  id: 'new-project-view'

  events:
    'keypress #new-project'  : 'createOnEnter'

  render: ->
    @$(@el).html newProjectTemplate()
    @

  newAttributes: ->
    attributes.name = @$("#new-project").val() if @$("#new-project").val()
    attributes

  createOnEnter: (event) ->
    return unless event.keyCode is $.ui.keyCode.ENTER
    app.collections.projects.create @newAttributes()
    @$("#new-project").val ''
