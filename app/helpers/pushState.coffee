app.util.clickHandler = (e) ->
  # If the click target isn't a link, then return
  unless e.target.tagName is 'A' and $(e.target).attr('href')? then return
  href = $(e.target).attr('href')
  # If the clicked link is "/logout" then let it continue
  if _.include ['/logout'], href
    return
  if href is '/settings'
    e.preventDefault()
    # Hide dropdown.
    app.views.managementView.hide()
    # Call settings controller.
    app.routers.main.settings()
    return
  unless $(e.target).attr('href').indexOf('http') is 0
    e.preventDefault()
    app.routers.main.navigate(href, {trigger: true})

$(window).on 'click', app.util.clickHandler
