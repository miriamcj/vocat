define (require) ->

  template = require('hbs!templates/rubric/range_picker')
  jqui = require('jquery_ui')
  Marionette= require('marionette')

  class RangePickerView extends Marionette.ItemView

    template: template

    ui: {
      'handle': '[data-behavior="draggable"]'
      'resizable': '[data-behavior="resizable"]'
      'rangePicker': '[data-behavior="range-picker"]'
    }

    serializeData: () ->
      highs = @collection.collect( (model) -> parseInt(model.get('high')))
      lowRange = @collection.min((model) -> parseInt(model.get('low')))
      unless lowRange == Infinity
        low = parseInt(lowRange.get('low'))
      else
        low = 0
      handles = []
      high = highs.pop()
      handles = []
      _.each(highs, (oneHigh) ->
        deduct = _.reduce(handles, (memo, handle) ->
          memo + handle.width
        , 0)
        handles.push({
          width: (((oneHigh - low) / (high - low)) * 100) - deduct
          high: oneHigh
        })
      )
      {
        ranges: @collection.toJSON()
        handles: handles
      }

    onShow: () ->

      totalWidth = 922

      @cachedWidths = []

      @ui.resizable.each((index, el) =>

        $el = $(el)
        @cachedWidths[index] = $el.width()
        $el.find('b').html(@cachedWidths[index])
        console.log @cachedWidths


        $el.resizable({
          handles: 'e'
          minHeight: 34
          maxHeight: 34

          resize: (event, ui) =>

            cachedWidth = @cachedWidths[index]
            next = @ui.resizable.eq(index + 1)
            diff = ui.size.width - cachedWidth
            nextWidth = next.width()
            newNextWidth = nextWidth - diff
            if newNextWidth >= 22
              next.width(newNextWidth)
            else
              ui.element.width(ui.size.width - diff)
              ui.size.width = ui.size.width - diff


            @cachedWidths[index + 1] = nextWidth
            total = _.reduce(@ui.resizable, (memo, el) ->
              memo + $(el).width()
            , 0)
            totalDiff = total - totalWidth
            if totalDiff > 0
              newWidth = ui.size.width - totalDiff
              ui.element.width(newWidth)
              ui.size.width = newWidth
            ui.element.find('b').html(ui.size.width)
            @cachedWidths[index] = ui.size.width

            console.log @cachedWidths
        })
      )

#      @ui.handle.each((index, handle) =>
#        $(handle).draggable({
#          axis: "x",
#          containment: "parent"
#          drag: (event, ui) =>
#            parent = $(event.target).parent()
#        })
#      )

    initialize: (options) ->
      @vent = options.vent
