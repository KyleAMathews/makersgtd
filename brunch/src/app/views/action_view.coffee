actionTemplate = require('templates/action')
InjectModelMenu = require('mixins/views/inject_model_menu').InjectModelMenu

class exports.ActionView extends Backbone.View

  tagName:  "li"

  events:
    'click .check'           : 'injectModelMenu'

  initialize: ->
    @model.bind('change', @render)
    @model.bind('destroy', @remove)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = @model.iurl()
    @$(@el).html(actionTemplate(
      action: json
    ))
    @

  toggleDone: ->
    @model.toggle()

  injectModelMenu: (e) =>
    if e.currentTarget.checked
      app.models.contextMenu.add(@model)
    else
      app.models.contextMenu.remove(@model)

# Add Mixins InjectModelMenu
exports.ActionView.prototype = _.extend exports.ActionView.prototype,
  InjectModelMenu
