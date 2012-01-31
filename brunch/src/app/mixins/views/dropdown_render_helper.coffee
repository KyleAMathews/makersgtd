DropdownMenuView = require('views/dropdown_menu_view').DropdownMenuView
exports.DropdownRenderHelper =
  renderDropdown: ->
    @logChildView @dropdownMenu = new DropdownMenuView(
      el: @$el.find('.dropdown')
      model: @model
    ).render()

    # Add hoverIntent.
    config =
      over: @showDropdown
      out: @hideDropdown
      timeout: 100
    @$el.hoverIntent(config)

  showDropdown: ->
    @$el.find('.dropdown').addClass('over')

  hideDropdown: ->
    @$el.find('.dropdown').removeClass('over')
    @dropdownMenu.hide()
