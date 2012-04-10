app.util.clickHandler = (e) ->
  # If the click target isn't a link, then return
  unless e.target.tagName is 'A' and $(e.target).attr('href')? then return
  # If the clicked link is "/logout" then let it continue
  if _.include ['/logout'], $(e.target).attr('href')
    return
  unless $(e.target).attr('href').indexOf('http') is 0
    # Prevent click from reloading page.
    e.preventDefault()
    href = $(e.target).attr('href')
    app.routers.main.navigate(href, {trigger: true})

$(window).on 'click', app.util.clickHandler
