ModalTemplate = require 'widgets/modal/modal'
class exports.ModalView extends Backbone.View

  className: 'modal'

  render: ->
    @$el.html ModalTemplate( @options )
    $( @el ).modal()
    @
