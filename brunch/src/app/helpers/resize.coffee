resize = ->
  windowWidth = $(window).width()
  unit = windowWidth / 65

  # Set some useful global variables
  if windowWidth < 400
    app.device = 'mobile'
  else if windowWidth < 1170
    app.device = 'small'
  else
    app.device = 'large'

  if $(window).width() > 400
    $('#global-search').css('margin-left', 100)
    $('#global-search').css('width', 300)

    # Set max and min
    if unit > 27 then unit = 27
    if unit < 18 then unit = 18

    # If width is to small, set body width such that everything fits.
    if unit is 18
      $('body').width(unit * 65)
    else
      $('body').width('auto')

    # Panes
    $('.pane').css('margin-left', unit)
    $('.pane').css('width', unit * 15)

    # SimpleGTD pane
    $('#simple-gtd-app').css('margin-left', unit)
    $('#simple-gtd-app').css('width', unit * 15)
    $('nav').css('margin-left', unit)
    $('nav').css('width', unit * 14)
    $('#shadow-cover').css('margin-left', unit + 2)
    $('#shadow-cover').css('width', unit * 14)
  else
    winWidth = $(window).width() - 5
    $('body').width('auto')
    $('#global-search').css('margin-left', 0)
    $('#global-search').css('width', winWidth - 25)
    # This code runs before panes are setup sometimes.
    if app.pane1?
      app.pane1.hide()
      app.pane2.hide()
      app.pane3.hide()
    # Panes
    $('.pane').css('margin-left', 0)
    $('.pane').css('width', winWidth)

    # SimpleGTD pane
    $('#simple-gtd-app').css('margin-left', 0)
    $('#simple-gtd-app').css('width', winWidth)
    $('nav').css('margin-left', 0)
    $('nav').css('width', winWidth)
    $('#shadow-cover').css('margin-left', 2)
    $('#shadow-cover').css('width', winWidth-2)


$ ->
  resize()
  throttled = _.throttle(resize, 100)
  $(window).resize(throttled)
