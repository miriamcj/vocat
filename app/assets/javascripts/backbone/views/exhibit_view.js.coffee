class Vocat.Views.Exhibit extends Backbone.View

	template: HBT["backbone/templates/exhibit"]

	currentUseRole: 'not_owner'

	initialize: (options) ->
		if options.currentUserRole? then @currentUseRole = options.currentUseRole

	render: () ->
    context = {
      exhibit: @model.toJSON()
    }
    @$el.html(@template(context))
