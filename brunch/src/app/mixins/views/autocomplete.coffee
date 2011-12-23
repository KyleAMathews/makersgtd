exports.Autocomplete =
  selectResult: (e) ->
    # Exit editing on escape.
    if e.keyCode is $.ui.keyCode.ESCAPE then @stopEditing()

    # When the user presses the down arrow, select the next item in the matches.
    if e.keyCode is $.ui.keyCode.DOWN
      @$('ul.autocomplete li.active').removeClass('active').nextAll('li').first().addClass('active')
      if @$('ul.autocomplete li.active').length is 0
        @$('ul.autocomplete li').last().addClass('active')
      e.preventDefault()

    # When the user presses the up arrow, select the previous item in the matches.
    if e.keyCode is $.ui.keyCode.UP
      @$('ul.autocomplete li.active').removeClass('active').prevAll('li').first().addClass('active')
      if @$('ul.autocomplete li.active').length is 0
        @$('ul.autocomplete li').first().addClass('active')
      e.preventDefault()

  # Select the item the mouse is hovering over.
  hoverSelect: (e) ->
    @$('ul.autocomplete li.active').removeClass('active')
    $(e.target).addClass('active')
