tagTemplate = require('templates/tag')
InjectModelMenu = require('mixins/views/inject_model_menu').InjectModelMenu

class exports.TagView extends Backbone.View

  tagName:  "li"

  events:
    'click .check'           : 'injectModelMenu'

  initialize: ->
    @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = '#' + @model.url().substr(1)
    @$(@el).html(tagTemplate(tag: json))
    @

# Add Mixins InjectModelMenu
exports.TagView.prototype = _.extend exports.TagView.prototype,
  InjectModelMenu
