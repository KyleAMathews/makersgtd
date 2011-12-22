metaInfoTemplate = require('templates/meta_info')

class exports.MetaInfoView extends Backbone.View

  className: 'meta-info'

  initialize: ->
    @model.view = @

  render: =>
    $(@el).html(metaInfoTemplate( @model.toJSON() ))
    @
