class Vocat.Views.RubricBuilder extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/rubric_builder"]

	initialize: (options) ->
		@model = new Vocat.Models.Rubric({})

		@model.addField {name: 'Voice', description: 'Breathing; Centering; Projection' }
		@model.addField {name: 'Body', description: 'Relaxation; Physical tension; Eye-contact; Non-verbal communication' }
		@model.addField {name: 'Expression', description: 'Concentration; Focus; Point of View; Pacing' }
		@model.addField {name: 'Overall Effect', description: 'Integration of above categories; connection with audience' }
		@model.addRange {name: 'Low', low: 1, high: 2}
		@model.addRange {name: 'Medium', low: 3, high: 4}
		@model.addRange {name: 'High', low: 5, high: 6}

		super (options)
		@render()

	render: () ->
		context = {
			rubric: @model.toJSON()
		}

		@$el.html(@template(context))

		new Vocat.Views.RubricBuilderStructure({model: @model, el: $('#js-rubric_builder_structure')})


