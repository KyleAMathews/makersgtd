actionTemplate = require('templates/action')

class exports.ActionView extends Backbone.View

  tagName:  "li"

  events:
    'click .checkbox': "toggleDone"

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @bindTo(@model, 'change', @render)
    @bindTo(@model, 'destroy', @remove)
    @bindTo(@model, 'remove', @remove)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = @model.iurl()
    @$el.html(actionTemplate(
      action: json
    ))
    @$('span.date').timeago()
    @

  toggleDone: =>
    @model.toggle()
