class Vocat.Views.RubricBuilder extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/rubric_builder"]

	initialize: (options) ->
		@model = new Vocat.Models.Rubric({})

		@model.addField 'Body'
		@model.addField 'Voice'
		@model.addField 'Eye Contact'
		@model.addRange 'Low'
		@model.addRange 'Medium'
		@model.addRange 'High'

		super (options)
		@render()

	render: () ->
		context = {
			rubric: @model.toJSON()
		}

		@$el.html(@template(context))

		new Vocat.Views.RubricBuilderStructure({model: @model, el: $('#js-rubric_builder_structure')})


