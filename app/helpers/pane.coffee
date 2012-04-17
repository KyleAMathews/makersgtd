# Code partially borrowed from https://github.com/derickbailey/backbone.marionette
class exports.Pane

  constructor: (options) ->
    @options = options || (options = {})
    if !@options.el
      throw new Error("An 'el' must be specified")
    @$el = $(@options.el)

  # Displays a backbone view instance inside of the region.
  # Handles calling the `render` method for you. Reads content
  # directly from the `el` attribute. Also calls an optional
  # `onShow` and `close` method on your view, just after showing
  # or just before closing the view, respectively.
  show: (view) ->
    # Check if the new view is the same as the old view.
    # Compare collections first
    unless app.device is 'mobile'
      if @currentView? and view.collection and view.collection is @currentView.collection
        return
      else if @currentView? and view.model and view.model.id is @currentView.model.id
        return

    oldView = @currentView
    @currentView = view

    @_closeView oldView
    @_openView view

    if app.device is 'mobile'
      window.scrollTo(0,0)
    #else if app.device is 'small' # Scroll left and right

    app.eventBus.trigger('pane:show')

  hide: ->
    @currentView = null
    @$el.empty()
    @$el.hide()
    app.eventBus.trigger('pane:hide')

  _closeView: (view) ->
    if view && view.close
      view.close()

  _openView: (view) ->
    @$el.html view.render().el
    @$el.show()
    if view.onShow
      view.onShow()

      # hierarchy -- meta > context > project > action > note
      # build paneFactory which returns correct pane -- it looks at type
      # of view plus types of views already displayed and picks next
      # one
  type: ->
    if @currentView? and @currentView.model?
      return @currentView.model.get('type')
    else
      'empty'

  getModel: ->
    if @currentView?.model?
      return @currentView.model
    else
      return false

  visible: ->
    return @$el.is(':visible')
