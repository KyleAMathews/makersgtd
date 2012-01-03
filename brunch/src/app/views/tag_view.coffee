tagTemplate = require('templates/tag')

class exports.TagView extends Backbone.View

  tagName:  "li"

  initialize: ->
    @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = '#' + @model.url().substr(1)
    @$(@el).html(tagTemplate(tag: json))
    @
