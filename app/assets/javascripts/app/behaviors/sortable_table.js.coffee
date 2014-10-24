define (require) ->

  Marionette = require('marionette')
  require('jquery_ui')

  class SortableTable extends Marionette.Behavior

    defaults: {
    }

    ui: {
      table: 'tbody'
    }

    initialize: () ->
      @listenTo(@, ('childview:update-sort'), (rowView, args) =>
        @updateSort(args[0], args[1])
      )

    onRender: () ->
      @ui.table.sortable({
        revert: true
        handle: '.row-handle'
        items: 'tr:not([data-ui-behavior="drag-disabled"])'
        cursor: "move"
        start: (event, ui) =>
          # TODO: Assign widths to the dragged row.
          handle = ui.item.find('.row-handle')
          w = handle.outerWidth()
          @ui.table.find('.row-handle').each (index, el) =>
            console.log $(el).outerWidth(w)

        stop: (event, ui) ->
          ui.item.trigger('drop', ui.item.index())
      })

    updateSort: (model, position) ->
      adjustedPosition = position
      @view.collection.remove(model)
      model.set('listing_order_position', adjustedPosition)
      @view.collection.add(model, {at: position})
      model.save()
#      @view.render()
