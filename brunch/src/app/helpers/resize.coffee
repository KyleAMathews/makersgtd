resize = ->
  windowWidth = $(window).width()
  unit = windowWidth / 45

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

$ ->
  resize()
  throttled = _.throttle(resize, 100)
  $(window).resize(throttled)
