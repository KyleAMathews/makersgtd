addNewModelTemplate = require('templates/add_new_model')
ExpandingAreaView = require('views/expanding_area_view').ExpandingAreaView

class exports.AddNewModelView extends Backbone.View

  className: 'add-new-model'

  events:
    'keypress .input' : 'save'

  render: =>
    context = {}
    for k,v of @options
      context[k] = v

    $(@el).html(addNewModelTemplate(context))
    new ExpandingAreaView(
      el: @$('.expanding-area')
      placeholder: "Add new " + context.type
    ).render()
    @

  save: (e) =>
    console.log @$('span')
    if e.keyCode is $.ui.keyCode.ENTER
      # Save new model
      collection = @options.type + "s"
      app.collections[collection].create @newAttributes()
      self = @
      _.defer ->
        self.$('textarea').val('')
        self.$('span').empty()

  newAttributes: ->
    attributes =
      order: 150
    attributes.name = @$("textarea").val() if @$("textarea").val()?
    return attributes
