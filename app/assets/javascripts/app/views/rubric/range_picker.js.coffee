define (require) ->

  template = require('hbs!templates/rubric/range_picker')
  jqui = require('jquery_ui')
  Marionette= require('marionette')

  class RangePickerView extends Marionette.ItemView

    template: template

    ui: {
      'handle': '[data-behavior="draggable"]'
      'draggable': '[data-behavior="draggable"]'
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

    checkForCollision: (ui) ->
      console.log ui

    onShow: () ->

      totalWidth = 922
      draggablePositions

      @ui.draggable.each((index, handle) =>
        $handle = $(handle)
        draggablePositions[index] = $handle.position().left
      )
      console.log draggablePositions,'test'

      @ui.draggable.each((index, handle) =>

        $handle = $(handle)


        $handle.draggable({
          axis: "x",
          containment: "parent"
          drag: (event, ui) =>
            @checkForCollision(ui)
        })
      )

    initialize: (options) ->
      @vent = options.vent
