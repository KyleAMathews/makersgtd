tagTemplate = require('templates/tag_full')

class exports.TagFullView extends Backbone.View

  id: 'tags'
  className: 'full-view'

  events:
    'keypress .on-enter .input'   : 'updateOnEnter'
    'click .edit-link' : 'edit'
    'click .edit .save' : 'update'
    'click .edit .cancel' : 'stopEditing'
    'click .blank-slate' : 'edit'

  initialize: ->
    @model.bind('change', @render)
    @model.view = @

  render: =>
    @$(@el).html(tagTemplate(tag: @model.toJSON()))
    # @$('.editable').each ->
    #   if $('.display', @).length > 0
    #     $(@el, @).hover(
    #       =>
    #         @$('.edit-link').show()
    #       =>
    #         @$('.edit-link').hide()
    #     )
    @

  edit: (e) =>
    @$(e.target).parent().addClass "editing"
    @$(e.target).parent().find('.input').focus()

  stopEditing: (e) =>
    @$(e.target).parent().parent().removeClass "editing"

  update: =>
    @model.save(
      name: @$('.name .input').val()
      description: @$('.description .input').val()
    , {silent: true})
    @model.trigger('change')

  updateOnEnter: (e) ->
    @update() if e.keyCode is $.ui.keyCode.ENTER

