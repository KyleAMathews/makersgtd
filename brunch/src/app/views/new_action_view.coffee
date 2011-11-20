newActionTemplate = require('templates/new_action')

class exports.NewActionView extends Backbone.View

  id: 'new-action-view'

  events:
    'keypress #new-action'  : 'createOnEnter'

  render: ->
    @$(@el).html newActionTemplate()
    @

  newAttributes: ->
    attributes =
      order: app.collections.actions.nextOrder()
    attributes.content = @$("#new-action").val() if @$("#new-action").val()
    attributes

  createOnEnter: (event) ->
    return unless event.keyCode is $.ui.keyCode.ENTER
    app.collections.actions.create @newAttributes()
    @$("#new-action").val ''
