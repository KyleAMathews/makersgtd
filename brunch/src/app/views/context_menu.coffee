contextMenuTemplate = require('templates/context_menu')

class exports.ContextMenu extends Backbone.View

  initialize: ->
    @model.bind('change', @render)
    $(window).on('hashchange', @empty)

  events:
    'click .delete': 'delete'
    'click .complete': 'complete'

  render: =>
    action = false
    project = false
    tag = false
    types = _.uniq(_.map(@model.get('models'), (model) -> return model.get('type')))
    for type in types
      switch type
        when 'action' then action = true
        when 'project' then project = true
        when 'tag' then tag = true

    @$(@el).html( contextMenuTemplate(
      models: @model.get('models')
      count: @model.get('models').length
      types: types
      action: action
      project: project
      tag: tag
    ) )
    # Keep context_menu fixed while scrolling.
    a = () =>
      b = $(window).scrollTop()
      d = @$(@el).offset().top - 60
      if b > d and d > 84
        @$(@el).css( position:"fixed",top:"50px" ).addClass('floating')
      else
        @$(@el).css( position:"relative",top:"" ).removeClass('floating')

    $(window).scroll(a);a()
    @

  complete: =>
    for model in @model.get('models')
      model.toggle()
    @empty()

  delete: =>
    for model in @model.get('models')
      model.delete()
    @empty()

  empty: =>
    # Empty the context menu's store of models
    @model.set( models: [] )
    @model.trigger('change')
