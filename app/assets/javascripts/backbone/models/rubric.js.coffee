class Vocat.Models.Rubric extends Backbone.RelationalModel

	initialize: (options) ->
		@set 'fields', new Array
		@set 'ranges', new Array

	addField: (value) ->
		if _.isObject(value) then field = value else field = { 'name': value, description: 'Enter a description...'}
		fields = _.clone @get 'fields'
		fields.push field
		@set {'fields', fields}, {validate: true}

	removeField: (name) ->
		fields = _.clone @get 'fields'
		@set {'fields': _.reject fields, (field) -> field.name == name}, {validate: true}

	addRange: (value) ->
		if _.isObject(value) then range = value else range = { 'name': value, low: @nextRangeLowValue(), high: @nextRangeHighValue()}
		ranges = _.clone @get 'ranges'
		ranges.push range
		@set {'ranges', ranges}, {validate: true}

	highestHigh: (ranges = null) ->
		if ranges == null then ranges = @get 'ranges'
		if ranges.length == 0 then 0 else _.max _.pluck ranges, 'high'

	lowestLow: (ranges = null) ->
		if ranges == null then ranges = @get 'ranges'
		if ranges.length == 0 then 0 else _.min _.pluck ranges, 'low'

	averageRangeIncrement: (ranges = null) ->
		if ranges == null then ranges = @get 'ranges'
		high = @highestHigh()
		if ranges.length > 1 then avg = high / ranges.length else avg = 1

	nextRangeLowValue: () ->
		@highestHigh() + 1

	nextRangeHighValue: () ->
		averageIncrement = @averageRangeIncrement()
		console.log averageIncrement, 'avg'
		@highestHigh() + averageIncrement

	clone: (array) ->
		out = new Array()
		_.each(array, (item) -> out.push _.clone(item))
		out

	removeRange: (name) ->
		ranges = @clone @get 'ranges'
		@set {'ranges': _.reject ranges, (range) -> range.name == name}, {validate: true}

	updateRangeBound: (name, type, value) ->
		ranges = @clone @get 'ranges'
		_.each(ranges, (item) ->
			if item.name == name
				item[type] = parseInt(value)
		)
		ranges = @growOrShrinkRanges(ranges)
		@set {'ranges': ranges}, {validate: true}

	# TODO: This is totally not working.
	growOrShrinkRanges: (ranges) ->
		_.each(ranges, (item, index, list) ->
			console.log item, 'item'
			if index + 1 <= list.length - 1
				next = list[index+1]
				console.log next, 'next'
				item.high = next.low - 1
			if index - 1 >= 0
				previous = list[index-1]
				console.log prev, 'prev'
				item.low = previous.high + 1
			list[index] = item
		)
		ranges

	rangesHaveGaps: (ranges) ->
		if ranges.length <= 1 then return false # If there are no ranges or only one range, by definition there cannot be gaps.
		highestConsecutiveScore = _.reduce(ranges, (memo, range, index) ->
			if range.low == memo + 1 then memo = range.high
		, 0)
		if highestConsecutiveScore == @highestHigh(ranges) then false else true

	validateRanges: (attributes) ->
		ranges = attributes.ranges
		if @arrayHasEmpties(ranges) then return 'You cannot add an unnamed range'
		if @arrayHasDuplicates(ranges) then return 'No duplicate fields are permitted'
		if @rangesHaveGaps(ranges) then return 'Range gap or overlap error'
		return false

	validateFields: (attributes) ->
		if @arrayHasEmpties(attributes.fields) then return 'You cannot add an unnamed field'
		if @arrayHasDuplicates(attributes.fields) then return 'No duplicate fields are permitted'
		return false

	validate: (attributes, options) ->
		validateMethods = ['validateRanges', 'validateFields']

		errorMessage = false
		_.every validateMethods, (method) =>
			errorMessage = @[method](attributes)
			if errorMessage == false then true else false
		if errorMessage != false
			errorMessage

	arrayHasEmpties: (arr) ->
		res = _.find arr, (item) -> item == '' or item == false
		if !res? then false else true

	arrayHasDuplicates: (arr) ->
		if arr.length != _.uniq(arr, false, (item) -> item.name.toLowerCase()).length then true else false