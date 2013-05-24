class Vocat.Views.FlashMessages extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/flash_messages"]

	initialize: (options)  ->
		@scope = @$el.data('flash-scope')
		@msgs = []
		Vocat.Dispatcher.bind('flash', @addMessage, @)
		Vocat.Dispatcher.bind('flash:flush', @flushMessages, @)

	flushMessages: ->
		@msgs = []
		@render()

	addMessage: (args) ->
		# Add message if this container is scoped and the message is of the same scope
		# OR
		# Add message if this container is not scoped and the message isn't either
		if (@scope and args.scope and args.scope == @scope) or (not @scope and not args.scope)
			@msgs.push args
		@render()

	render: (args) ->
		context = {
			messages: @msgs
		}
		@$el.html(@template(context))