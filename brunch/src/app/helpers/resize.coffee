resize = ->
  windowWidth = $(window).width()
  unit = windowWidth / 45

  if $(window).width() > 400
    # Set max and min
    if unit > 40 then unit = 40
    if unit < 25 then unit = 25

    # If width is to small, set body width such that everything fits.
    if unit is 25
      $('body').width(unit * 45)
    else
      $('body').width('auto')

    # Panes
    $('.pane').css('margin-left', unit)
    $('.pane').css('width', unit * 10)

    # SimpleGTD pane
    $('#simple-gtd-app').css('margin-left', unit)
    $('#simple-gtd-app').css('width', unit * 10)
    $('nav').css('margin-left', unit)
    $('nav').css('width', unit * 9)
    $('#shadow-cover').css('margin-left', unit + 2)
    $('#shadow-cover').css('width', unit * 9)
  else
    winWidth = $(window).width() - 5
    $('body').width('auto')
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
