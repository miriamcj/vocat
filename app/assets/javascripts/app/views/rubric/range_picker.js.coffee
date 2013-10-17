define (require) ->

  template = require('hbs!templates/rubric/range_picker')
  jqui = require('jquery_ui')
  Marionette= require('marionette')

  class RangePickerView extends Marionette.ItemView

    template: template

    ui: {
      'draggableContainer': '[data-behavior="draggable-container"]'
      'handles': '[data-handle]'
      'rangePicker': '[data-behavior="range-picker"]'
      'ticks': '[data-container="ticks"]'
    }


    serializeData: () ->
      handles = []
      @collection.each((range, index) =>
        handles.push(range.get('low'))
      )
      handles.push(@model.get('high'))
      {
        handles: handles
        high: @model.getHigh()
        low: @model.getLow()
      }

    snapToTick: ($el, left) ->
      previousTick = Math.floor(left / @tickInc) * @tickInc
      nextTick = Math.ceil(left / @tickInc) * @tickInc
      if (left - previousTick) < (nextTick - left)
        return previousTick
      else
        return nextTick

      remainder = left % @tickInc
      if remainder >= @tickInc / 2
        left = left + remainder
      else
        left = left - remainder
      return left

    updateLabel: ($el, left) ->
      score = @getScoreFromLeft(left)
      $el.find('.dragger-label').html(score)

    updatePositions: (ui) ->
      @updateLabel(ui.helper, ui.position.left)

    getTickCountForRange: (range) ->
      ticks = 0
      _.each([0..range], (i) ->
        if range % i == 0 && i <= 20
          ticks = i
      )
      if range < 10
        ticks == range
      else if ticks < 5
        ticks = 10
      ticks

    moveTo: ($dragger, score) ->
      target = @getLeftFromScore(score)
      $dragger.css({left: target})
      @updateLabel($dragger, target)

    updateTicks: () ->
      @ui.ticks.empty()
      tickCount = @getPossibleValueCount()
      visibleTickCount = @getTickCountForRange(tickCount)
      @updateTickInc()
      i = 1
      while i < visibleTickCount
        tickNumber = tickCount / visibleTickCount * i
        left = tickNumber * @tickInc
        score = @getScoreFromLeft(left)
        html = '<div style="left: ' + left + 'px" class="mark"><span>' + score + '</span></div>'
        @ui.ticks.append(html)
        i++

    updateTickInc: () ->
      @tickInc = @getRangePickerWidth() / @getPossibleValueCount()

    getRangePickerWidth: () ->
      @ui.rangePicker.width()

    getPossibleValueCount: () ->
      @model.get('high') - @model.get('low')

    getScoreFromLeft: (left) ->
      if left == 0
        score = @model.get('low')
      else
        tickPosition = left / @tickInc
        score = Math.round(tickPosition + @model.get('low'))
      score

    getLeftFromScore: (score) ->
      adjustedScore = score - @model.get('low')
      adjustedScore * @tickInc

    fixValues: (values) ->
      newValues = values.slice(0) # clone it

      sortIterator = (aValue) ->
        out = parseInt(aValue)
      newValues = _.sortBy(newValues, sortIterator)

      # Remove the highest and lowest values
      newValues.unshift()
      newValues.pop()

      # And add the correct high and low values
      newValues.push(@model.get('low'))
      newValues.push(@model.get('high'))
      newValues = _.uniq(newValues)

      targetCount = @collection.length + 1
      newValues = _.filter(newValues, (value) =>
        value <= @model.get('high') && value >= @model.get('low')
      )

      newValues = _.sortBy(newValues, sortIterator)

      missingCount = targetCount - newValues.length
      if missingCount < 0 && newValues.length > 2
        newValues.splice(1, 1)

      while missingCount > 0
        missing = []
        for value, i in newValues
          if newValues[i + 1] - newValues[i] != 1
            x = newValues[i + 1] - newValues[i]
            j = 1
            while j < x
              missing.push(newValues[i] + j)
              j++
        if missing.length > 0 then newValues.push _.max(missing)
        newValues = _.sortBy(newValues, sortIterator)
        missingCount--

      newValues = _.uniq(newValues)
      newValues

    updateCollection: () ->
      if @collection.length > 0
        values = @getValues()
        updates = []
        _.each(values, (value, index) =>
          # Unless it's not the last one
          unless index + 1 == values.length
            if index == 0
              low = value
            else
              low = value
            if index + 1 == values.length - 1
              high = values[index + 1]
            else
              high = values[index + 1] - 1
            updates.push({low: low, high: high})
        )
        _.each(updates, (update, index) =>
          range = @collection.at(index)
          if range?
            range.set(update)
        )

    getValues: () ->
      values = []
      _.each(@handles, (handle) =>
        $handle = $(handle)
        if $handle.is(':visible')
          left = $handle.position().left
          score = @getScoreFromLeft(left)
          values.push score
      )
      values = _.sortBy(values, (value) ->
        parseInt(value)
      )
      values

    getValuesFromCollection: (collection) ->

      if collection.length > 0
        # Assumed collection is sorted correctly (by low)
        values = collection.pluck('low')
        values.push collection.last().get('high')
        values
      else
        []


    initializeUi: () ->

      @handles = []

      # Setup ticks
      @updateTicks()

      values = @getValuesFromCollection(@collection)
      values = @fixValues(values)

      @ui.draggableContainer.empty()
      _.each(values, (value, index) =>
        $handle = $('<div style="position: absolute" class="dragger" data-handle data-behavior="draggable"><div class="dragger-label"></div></div>')
        @ui.draggableContainer.append($handle)
        @moveTo($handle, value)
        @handles.push($handle)
        unless index == 0 || index + 1 == values.length
          $handle.draggable({
            axis: "x",
            containment: "parent"
            drag: (event, ui) =>
              @updatePositions(ui)
            stop: (event, ui) =>
              newLeft = @snapToTick(ui.helper, ui.position.left)
              ui.helper.animate({left: newLeft}, 200)
              @updateCollection()
          })
      )
      @updateCollection()


    onRender: () ->
      @initializeUi()

    onShow: () ->
      @initializeUi()

    initialize: (options) ->
      @vent = options.vent

      @listenTo(@model,'change:low change:high', () =>
        @render()
      )

      @listenTo(@collection, 'add remove', () =>
        @render()
      )

