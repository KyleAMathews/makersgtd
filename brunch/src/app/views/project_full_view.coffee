projectTemplate = require('templates/project_full')
editableTemplate = require('templates/editable')

class exports.ProjectFullView extends Backbone.View

  className: 'full-view'
  id: 'projects'

  events:
    'keypress .on-enter .input'   : 'updateOnEnter'
    'click .editable .display' : 'edit'
    'click .edit .save' : 'update'
    'click .edit .cancel' : 'stopEditing'
    'click .blank-slate' : 'edit'

  initialize: ->
    @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.description_html = @model.getHtml('description')
    @$(@el).html(projectTemplate(project: json, editableTemplate: editableTemplate ))

    # Make sure HTML is finished being inserted.
    callback = -> $('.expanding-area').makeExpandingArea()
    setTimeout callback, 0
    @

  edit: (e) =>
    @$(e.target).closest('.editable').addClass "editing"
    @$(e.target).closest('.editable').find('.input').focus()

  stopEditing: (e) =>
    @$(e.target).parent().parent().removeClass "editing"

  update: =>
    fields = {}
    @$('.editable').each ->
      fields[$(@).data('field')] = $(@).find('.input').val()

    @model.save(
      fields
    , {silent: true})
    @model.trigger('change')

  updateOnEnter: (e) ->
    @update() if e.keyCode is $.ui.keyCode.ENTER
