newTagTemplate = require('templates/new_tag')

class exports.NewTagView extends Backbone.View

  id: 'new-tag-view'

  events:
    'keypress #new-tag'  : 'createOnEnter'

  render: ->
    @$(@el).html newTagTemplate()
    @

  newAttributes: ->
    attributes =
      order: app.collections.tags.nextOrder()
    attributes.name = @$("#new-tag").val() if @$("#new-tag").val()
    attributes

  createOnEnter: (event) ->
    return unless event.keyCode is $.ui.keyCode.ENTER
    app.collections.tags.create @newAttributes()
    @$("#new-tag").val ''
