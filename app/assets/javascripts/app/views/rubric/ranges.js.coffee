define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/rubric/ranges')
  RangeView = require('views/rubric/range')
  jqui = require('jquery_ui')

  class RangesView extends Marionette.CompositeView

    template: template
    className: 'ranges-wrapper'
    childViewContainer: '[data-region="range-columns"]'
    childView: RangeView

    ui: {
      rangeAdd: '.range-add-button'
    }

    childViewOptions: () ->
      {
      collection: @collection
      rubric: @rubric
      criteria: @criteria
      vent: @vent
      }

    childEvents: () ->
      'move:right': 'moveRight'
      'move:left': 'moveLeft'

    # This function validates the values array to make sure
    # there are enough values, no duplicates, etc.
    fixValues: (values) ->
      newValues = values.slice(0) # clone it
      sortIterator = (aValue) ->
        out = parseInt(aValue)

      newValues = _.sortBy(newValues, sortIterator)

      # And add the correct high and low values
      newValues.push(@rubric.get('low'))
      newValues.push(@rubric.get('high'))
      newValues = _.uniq(newValues)

      targetCount = @collection.length + 1
      newValues = _.filter(newValues, (value) =>
        value <= @rubric.get('high') && value >= @rubric.get('low')
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
    updateCollection: (values) ->
      if @collection.length > 0
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

    moveRight: (childView) ->
      currentPosition = $('[data-region="cells"]').position()
      @collection.comparator = 'index'
      @model = childView.model
      @nextModel = @collection.at(@model.get('index') + 1)
      unless @model.index == @collection.length - 1
        @model.set('index', @model.get('index') + 1)
        @nextModel.set('index', @model.get('index') - 1)
        @collection.sort()
        @vent.trigger('range:move:right', currentPosition: currentPosition)

    moveLeft: (childView) ->
      currentPosition = $('[data-region="cells"]').position()
      @collection.comparator = 'index'
      @model = childView.model
      @nextModel = @collection.at(@model.get('index') - 1)
      unless @collection.indexOf(@model) == 0
        @model.set('index', @model.get('index') - 1)
        @nextModel.set('index', @model.get('index') + 1)
        @collection.sort()
        @vent.trigger('range:move:left', currentPosition: currentPosition)

    showRangeAdd: () ->
      if @collection.length > 3
        $(@ui.rangeAdd).css('display', 'none')
      else
        $(@ui.rangeAdd).css('display', 'inline-block')

    onShow: () ->
      @showRangeAdd()

    initialize: (options) ->
      @vent = options.vent
      @rubric = options.rubric
      @criteria = options.criteria
      @listenTo(@, 'add:child destroy:child remove:child', () ->
        values = @getValuesFromCollection(@collection)
        values = @fixValues(values)
        @updateCollection(values)
        @showRangeAdd()
      )
