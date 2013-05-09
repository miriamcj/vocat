class Vocat.Views.Groups extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/groups"]

	events:
		'click [data-behavior="create-group"]': 'createGroup'

	initialize: (options)  ->

		console.log 'called'
		if Vocat.Bootstrap.Collections.Group?
			@groups = new Vocat.Collections.Group(Vocat.Bootstrap.Collections.Group)
		if Vocat.Bootstrap.Collections.Creator?
			@creators = new Vocat.Collections.Creator(Vocat.Bootstrap.Collections.Creator)
		@render()
		@doPostRendering()

	createGroup: () ->
		name = @$el.find('[data-behavior="group-name"]').val()
		group = new Vocat.Models.Group({name: name})
		group.save()
		if group.validationError
			Vocat.Dispatcher.trigger('flash_message',{messages: group.validationError})

	doPostRendering: () ->
		userDroppable = @$el.find('.groups--owners-wrapper')
		console.log userDroppable.height()

	render: () ->
		context = {
			groups: @groups.toJSON()
			creators: @creators.toJSON()
		}
		@$el.html(@template(context))


#
#		@$el.find('[data-behavior="draggable-user"]').draggable({ revert: true})
#		@$el.find('[data-behavior="droppable-group"]').droppable({
#			drop: (e, ui) ->
#				droppedOn = $(@);
#				console.log droppedOn
#				$(ui.draggable).detach().css({top: 0,left: 0}).appendTo(droppedOn);
#		})
#
#
#		@$el.find('[data-behavior="droppable-user"]').droppable({
#			drop: (e, ui) ->
#				droppedOn = $(@);
#				console.log droppedOn
#				$(ui.draggable).detach().css({top: 0,left: 0}).appendTo(droppedOn);
#		})
