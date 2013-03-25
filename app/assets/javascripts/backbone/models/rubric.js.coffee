class Vocat.Models.Rubric extends Backbone.RelationalModel

	initialize: (options) ->
		@set 'fields', new Array
		@set 'ranges', new Array

	addField: (name) ->
		fields = @get 'fields'
		fields.push name
		@set 'fields', fields

	removeField: (name) ->
		fields = @get 'fields'
		@set 'fields', _.reject fields, (field) -> field == name

	addRange: (name) ->
		ranges = @get 'ranges'
		ranges.push name
		@set 'ranges', ranges

	removeRange: (name) ->
		ranges = @get 'ranges'
		@set 'ranges', _.reject ranges, (ranges) -> ranges == name
