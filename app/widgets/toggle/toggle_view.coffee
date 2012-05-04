ToggleTemplate = require 'widgets/toggle/toggle'
class exports.ToggleView extends Backbone.View

  events:
    'mousedown button': 'toggleActive'

  render: ->
    @$el.html ToggleTemplate( buttons: @options.buttons )
    @$('button').eq(0).addClass 'active'

    # Add fastClick support.
    if $.fn.fastClick?
      @$('button').fastClick (e) =>
        @toggleActive(e)
    @

  toggleActive: (e) ->
    unless $(e.target).hasClass 'active'
      @$('button').removeClass 'active'
      $(e.target).addClass 'active'
      @trigger 'toggle', $(e.target).data('machinename')

exports.ToggleView.prototype = _.extend exports.ToggleView.prototype, Backbone.Events
