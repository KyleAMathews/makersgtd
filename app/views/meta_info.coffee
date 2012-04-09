metaInfoTemplate = require('templates/meta_info')

class exports.MetaInfoView extends Backbone.View

  className: 'meta-info'

  initialize: ->
    @model.view = @
    @bindTo @model, 'change:created change:done change:changed', @render

  render: =>
    $(@el).html(metaInfoTemplate( @model.toJSON() ))
    @
