class Vocat.Views.FlashMessages extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/flash_messages"]

	initialize: (options)  ->
		@msgs = []
		Vocat.Dispatcher.bind('flash', @addMessage, @)
		Vocat.Dispatcher.bind('flash:flush', @flushMessages, @)

	flushMessages: ->
		@msgs = []
		@render()

	addMessage: (args) ->
		@msgs.push args
		@render()

	render: (args) ->
		context = {
			messages: @msgs
		}
		@$el.html(@template(context))