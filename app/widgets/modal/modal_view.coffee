ModalTemplate = require 'widgets/modal/modal'

module.exports = class ModalView extends Backbone.View

  className: 'modal'

  render: ->
    @$el.html ModalTemplate( @options )
    $( @el ).modal()
    @
