exports.GetHtml =
  getHtml: (property) ->
    if @get(property)?
      html = marked(@get(property))
      return html
    else
      return ''
