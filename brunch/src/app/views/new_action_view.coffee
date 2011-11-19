newActionTemplate = require('templates/new_action')

class exports.NewActionView extends Backbone.View

  id: 'new-action-view'

  events:
    'keypress #new-action'  : 'createOnEnter'
    'keyup #new-action'     : 'showHint'

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

  showHint: (event) ->
    tooltip = @$(".ui-tooltip-top")
    input = @$("#new-action")
    tooltip.fadeOut()
    clearTimeout(@tooltipTimeout) if @tooltipTimeout
    return if input.val() is '' or  input.val() is input.attr 'placeholder'
    fadeIn = ->
      tooltip.fadeIn()
    @tooltipTimeout = _.delay fadeIn, 1000
