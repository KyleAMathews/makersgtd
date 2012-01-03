DropdownMenuView = require('views/dropdown_menu_view').DropdownMenuView
exports.DropdownRenderHelper =
  renderDropdown: ->
    @dropdownMenu = new DropdownMenuView(
      el: @$('.dropdown')
      model: @model
    ).render()

    # Add hoverIntent.
    config =
      over: @showDropdown
      out: @hideDropdown
      timeout: 100
    $(@el).hoverIntent(config)
