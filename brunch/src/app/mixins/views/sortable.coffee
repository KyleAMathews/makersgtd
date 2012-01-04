exports.Sortable =
  makeSortable: (context) ->
    @$(context).sortable(
      start: (event, ui) ->
        $(event.target).parent().addClass('sorting')
      stop: (event, ui) ->
        $(event.target).parent().removeClass('sorting')
    )
    @$('ul').bind('sortupdate', @resetOrder)

  resetOrder: ->
    that = @
    order = []
    @$('li div.action').each (index) ->
      order.push $(@).data('id')

    @collection.saveOrder(order)
