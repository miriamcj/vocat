class Vocat.Views.FlashMessages extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/flash_messages"]

	initialize: (options)  ->
		Vocat.Dispatcher.bind('flash_message', @render, @)

	render: (args) ->
		context = {
			messages: args.messages
		}
		@$el.html(@template(context))