$ = jQuery

$.fn.makeExpandingArea = () ->
  @.each ->
    container = $(@)
    area = container.find('textarea')
    span = container.find('span')
    area.on 'input', ->
      span.text(area.val())
    span.text(area.val())

    # Enable extra CSS
    container.addClass('active')

