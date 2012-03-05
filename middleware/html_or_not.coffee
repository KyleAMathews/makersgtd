# Return index.jade if html is requested, otherwise return JSON or static files.
module.exports =
  handle: (req, res, next) ->
    if req.headers.accept? and req.headers.accept.indexOf('text/html') isnt -1
      res.render 'index'
    else
      next()
