class exports.ManagementView extends Backbone.View

  initialize: ->
    app.models.user.on 'change:name', @render
    $('html').on 'click.managementdropdown', @hide
    $('body').on 'click.managementdropdown', '#management', => @menuClicked = true

  events:
    'click .menu': 'toggleDropdown'

  toggleDropdown: ->
    @$el.toggleClass('active')

  hide: =>
    # If the menu was clicked, don't hide it.
    if @menuClicked is true
      @menuClicked = false
      return
    @$el.removeClass('active')

  render: =>
    @$('.name').html(app.models.user.get('name'))
    @
