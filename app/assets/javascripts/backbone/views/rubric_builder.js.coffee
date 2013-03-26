class Vocat.Views.RubricBuilder extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/rubric_builder"]

	events:
		'click .debug': 'debug'
		'click .js-save': 'save'


	debug: (event) ->
		event.preventDefault()
		console.clear()
		console.log @model, 'Full Model'
		console.log @model.toJSON(), 'JSON Representation'

	save: (event) ->
		event.preventDefault
		@model.save()

	initialize: (options) ->
		if Vocat.Bootstrap.Models.Rubric?
			@model = new Vocat.Models.Rubric(Vocat.Bootstrap.Models.Rubric, {parse: true})
		else
			@model = new Vocat.Models.Rubric({})

		# TODO: Remove this sample data once we have good rubric seed data in place.
#		d = new Date()
#		@model.set('name','Test Rubric ' + d.getTime())
#		@model.addField {name: 'Voice', description: 'Breathing; Centering; Projection' }
#		@model.addField {name: 'Body', description: 'Relaxation; Physical tension; Eye-contact; Non-verbal communication' }
#		@model.addField {name: 'Expression', description: 'Concentration; Focus; Point of View; Pacing' }
#		@model.addField {name: 'Overall Effect', description: 'Integration of above categories; connection with audience' }
#		@model.addRange {name: 'Low', low: 1, high: 2}
#		@model.addRange {name: 'High', low: 5, high: 6}
#		@model.addRange {name: 'Medium', low: 3, high: 4}
#		@model.setDescriptionByName('Voice', 'Low', 'Vocal projection is weak. Posture is crumpled or slouched: breath is unsupported. Volume is unamplified. One has to strain, or cannot hear speaker. Articulation is mushy and difficult to understand.')
#		@model.setDescriptionByName('Voice', 'Medium', 'Vocal projection fades in and out. Posture is off-balance: breathing is not always supported. Speaker\'s breathing is constricted by holding breath or too shallow. Volume loses amplification, particularly at end of sentences. Articulation is garbled or slurry, but distinct enough to be understood.')
#		@model.setDescriptionByName('Voice', 'High', 'Vocal projection is strong. Posture supports breath: feet are grounded and body centered, allowing deep breathing to power voice. Volume is sufficiently amplified and sustained at consistent level. Articulation is clear. Speaker is easily heard and understood.')
#		@model.setDescriptionByName('Body', 'Low', 'Body is rigidly tense, or nervous tension in constant movement, shuffling, or fidgeting. Speaker avoids eye contact and physically "hides" from audience. Gestures and non-verbal communication are excessive or restricted and unrelated to narrative.')
#		@model.setDescriptionByName('Body', 'Medium', 'Speaker is initially self-conscious and tense, but grows more relaxed as he/she continues. There is occasional eye-contact. There is some nervous movement fidgeting, but it decreases as presentation continues. Gestures and non-verbal communication do not always reinforce narrative.')
#		@model.setDescriptionByName('Body', 'High', 'Speaker is physically calm and appears relaxed. Speaker makes direct eye-contact. Physical presence projects animation and energy. Gestures and non-verbal communication enhance narrative.')
#		@model.setDescriptionByName('Expression', 'Low', 'Concentration is weak. Speaker cannot sustain concentration and is easily distracted: speaker giggles, or breaks away from what he/she is saying. There is no clear focus to the presentation and little emotional/intellectual connection to the narrative. Speaker rambles, or pauses awkwardly')
#		@model.setDescriptionByName('Expression', 'Medium', 'Concentration is disrupted. Speaker is distracted at times and loses focus, causing momentary hesitation. There are digressions from purpose. There is occasionally loss of emotional/intellectual connection to the narrative. Speaker rushes, or is monotone.')
#		@model.setDescriptionByName('Expression', 'High', 'Concentration is sustained throughout. The speaker is focused and clear about what he/she wants to say. There is a point of view and speaker appears to have an emotional/intellectual connection to their narrative.')
#		@model.setDescriptionByName('Overall Effect', 'Low', 'Tension impedes speaker from engaging audience. There is impatience and/or little interest in watching or listening to presentation. Ideas are incoherent, or nonexistent. Vocal and physical aspects of the presentation interfere with effective communication.')
#		@model.setDescriptionByName('Overall Effect', 'Medium', 'Speaker engages audience with varied success. Interest in the presentation ebbs and flows. Ideas are relatively clear, but lack overall coherence. Communication is effective, but neither dynamic nor very memorable.')
#		@model.setDescriptionByName('Overall Effect', 'High', 'Speaker engages audience and is compelling to watch and listen to. Ideas are clear, concise, and communicated in a creative, memorable way.')

		super (options)
		@render()

	render: () ->
		context = {
			rubric: @model.toJSON()
		}

		@$el.html(@template(context))

		@$el.find('.js-editable-input').each( (index, el) =>
			new Vocat.Views.RubricBuilderEditableInput({model: @model, el: el, property: 'name', placeholder: "Enter a name"})
		)

		new Vocat.Views.RubricBuilderStructure({model: @model, el: $('#js-rubric_builder_structure')})



