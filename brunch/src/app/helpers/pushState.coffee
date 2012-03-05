$(window).on 'click', (e) ->
  if not e.target.tagName is 'A' then return
  unless $(e.target).attr('href').indexOf('http') is 0
    # Prevent click from reloading page.
    e.preventDefault()
    href = $(e.target).attr('href')
    app.routers.main.navigate(href, {trigger: true})
