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

    fallBackWidth: 922

    # Snaps a dragger to the closest free tick.
    snapToTick: ($dragger, startPosition = null) ->
      values = @getValues()
      left = $dragger.position().left
      target = @getScoreFromLeft(left)
      movePreference = 'next'
      if startPosition? && startPosition < target then movePreference = 'previous'

      # Does the target value appear more than once in the values array? If so, we need to shunt
      # the $dragger to a new position.
      if _.filter(values, (value) -> value != target).length < (values.length - 1)
        missing = @getAvailableValues(values)
        # First we try to go up
        nextViableTarget = _.min(_.reject(missing, (value) -> value < target))
        previousViableTarget = _.max(_.reject(missing, (value) -> value > target))
        nextDistance = @getLeftFromScore(nextViableTarget) - left
        previousDistance = left - @getLeftFromScore(previousViableTarget)
        if nextDistance < previousDistance then target = nextViableTarget else target = previousViableTarget
      @moveTo($dragger, target, true)

    # Updates the handle label based on the $el's position
    updateLabel: ($el, left) ->
      score = @getScoreFromLeft(left)
      $el.find('.dragger-label').html(score)

    # Called when the draggers are dragged. Currently only triggers a label update
    handlePositionChange: (ui) ->
      @updateLabel(ui.helper, ui.position.left)

    # Returns the number of ticks to show for a given range (assuming we limit ticks to 10.
    getTickCountForRange: (range) ->
      ticks = 0
      _.each([0..range], (i) ->
        if range % i == 0 && i <= 15
          ticks = i
      )
      if range <= 15
        ticks == range
      else if ticks < 5
        ticks = 10
      ticks

    # Moves a dragger to a specific score. Can also animate the move, but does not do so by default.
    moveTo: ($dragger, score, animate = false) ->
      target = @getLeftFromScore(score)
      if animate == true
        $dragger.animate({left: target}, 200, () =>
          @updateCollection()
        )
      else
        $dragger.css({left: target})
        @updateCollection()

      @updateLabel($dragger, target)

    # Updates the tickes on the picker based on the current scale
    updateTicks: () ->
      @ui.ticks.empty()
      tickCount = @getPossibleTickCount()
      visibleTickCount = @getTickCountForRange(tickCount)
      @updateTickInc()
      i = 1
      while i <= visibleTickCount
        tickNumber = tickCount / visibleTickCount * i
        left = tickNumber * @tickInc
        score = @getScoreFromLeft(left)
        unless score == @model.get('high')
          html = '<div style="left: ' + left + 'px" class="mark"><span>' + score + '</span></div>'
          @ui.ticks.append(html)
        i++

    isPrime: (n) ->
      if _.isNaN(n) || !isFinite(n) || n % 1 || n < 2 then return false
      if n % 2 == 0 then return n == 2
      if n % 3 == 0 then return n == 3
      m = Math.sqrt(n)
      i = 5
      while i <= m
        return false  if n % i is 0
        return false  if n % (i + 2) is 0
        i += 6
      true

    # Calculates and sets the width of a tick on the range picker
    updateTickInc: () ->
      @tickInc = @getRangePickerWidth() / @getPossibleValueCount()

    # Calculates the width of the range picker
    getRangePickerWidth: () ->
      if @ui.rangePicker.is(':visible')
        width = @ui.rangePicker.width()
      else
        width = @fallBackWidth
      width

    # Gets the number of possible values for the model
    getPossibleValueCount: () ->
      @model.get('high') - @model.get('low')

    getPossibleTickCount: () ->
      valueCount = @getPossibleValueCount()
      isPrime = @isPrime(valueCount) && valueCount > 15
      if isPrime == true
        i = valueCount
        i-- while @isPrime(i) is true
        valueCount = i
      valueCount

    # Give a left position, it returns the corresponding integer value based on the current scale
    getScoreFromLeft: (left) ->
      if left == 0
        score = @model.get('low')
      else
        tickPosition = left / @tickInc
        score = Math.round(tickPosition + @model.get('low'))
      score

    # Given a score integer, it returns the corresponding left position
    getLeftFromScore: (score) ->
      adjustedScore = score - @model.get('low')
      adjustedScore * @tickInc

    # This function validates the values array to make sure
    # there are enough values, no duplicates, etc.
    fixValues: (values) ->
      newValues = values.slice(0) # clone it
      sortIterator = (aValue) ->
        out = parseInt(aValue)

      newValues = _.sortBy(newValues, sortIterator)

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

      newValues = _.uniq(newValues)

      while missingCount > 0
        bestGuess = @guessNextValue(newValues)
        if bestGuess? then newValues.push bestGuess
        newValues = _.sortBy(newValues, sortIterator)
        missingCount--
      newValues


    guessNextValue: (values) ->
      gap = @getLargestGapInSequence(values)
      guess = Math.floor((_.reduce(gap, (memo, num) -> memo + num) / 2))
      guess

    getLargestGapInSequence: (sequence) ->
      maxRanges = _.max(sequence) - _.min(sequence) + 1
      if sequence.length == maxRanges
        out = [_.max(sequence), _.max(sequence)]
      else
        gaps = _.map(sequence, (value, index) ->
          unless index == 0
            gap = value - sequence[index - 1] - 1
          else
            0
        )
        highIndex = _.indexOf(gaps, _.max(gaps))
        lowIndex = highIndex - 1
        out = [sequence[lowIndex], sequence[highIndex]]
      out

    getAvailableValues: (sequence) ->
      counts = _.countBy(sequence, (num) -> num)
      min = _.min(sequence)
      max = _.max(sequence)
      all = [min..max]
      available = _.filter(all, (num) ->
        _.indexOf(sequence, num, true) == -1 || (num == max && counts[num] <= 2 )
      )
      available

    # Returns an array of numbers that are missing from the sequence. Assumes
    # sequence is already sorted.
    getMissingFromSequence: (sequence) ->
      missing = []
      for value, i in sequence
        if sequence[i + 1] - sequence[i] != 1
          x = sequence[i + 1] - sequence[i]
          j = 1
          while j < x
            missing.push(sequence[i] + j)
            j++
      missing

    # Updates the ranges collection from the current values
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

    # Returns the values based on handle positions
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

    # Returns the values from the range collection
    getValuesFromCollection: (collection) ->
      if collection.length > 0
        values = collection.pluck('low')
        values = _.sortBy(values, (value) ->
          parseInt(value)
        )
        values
      else
        []

    # Sets up the range picker UI
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
          startPosition = 0
          $handle.draggable({
            axis: "x",
            containment: "parent"
            drag: (event, ui) =>
              @handlePositionChange(ui)
            start: (event, ui) =>
              _.each(@handles, ($dragger) =>
                $dragger.removeClass('dragger-active')
              )
              ui.helper.addClass('dragger-active')
              startPosition = ui.helper.position()
            stop: (event, ui) =>
              @snapToTick(ui.helper, startPosition.left)
              @updateCollection()
          })
        else
          if index == 0
            $handle.addClass('dragger-locked dragger-low')
          else
            $handle.addClass('dragger-locked dragger-high')
      )
      @updateCollection()


    onRender: () ->
      @initializeUi()

    onVisible: () ->
      @onShow()

    onShow: () ->
      if _.isObject(@ui.rangePicker)
        @initializeUi()

    initialize: (options) ->
      @vent = options.vent

      @listenTo(@, 'visible', @onVisible, @)

      @listenTo(@model, 'change:low change:high', () =>
        @render()
      )

      @listenTo(@collection, 'add remove', () =>
        @render()
      )

