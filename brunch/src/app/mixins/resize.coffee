resize = ->
  windowWidth = $(window).width()
  unit = windowWidth / 45

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
