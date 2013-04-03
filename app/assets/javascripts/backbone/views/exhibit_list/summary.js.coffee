class Vocat.Views.ExhibitSummary extends Vocat.Views.AbstractView

	ownerTemplate: HBT["backbone/templates/exhibit_list/exhibit_summary_owner"]
	otherTemplate: HBT["backbone/templates/exhibit_list/exhibit_summary_other"]

	initialize: (options) ->
		super (options)

	render: () ->
		context = {
		  exhibit: @model.toJSON()
		  organizationId: @organizationId
		}

		if context.exhibit.viewer.is_owner
			template = @ownerTemplate
		else
			template = @otherTemplate

		@$el.html(template(context))
