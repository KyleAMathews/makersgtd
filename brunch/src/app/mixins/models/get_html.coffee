exports.GetHtml =
  getHtml: (property) ->
    if @get(property)?
      html = markdown.makeHtml(@get(property))
      return html
    else
      return ''
