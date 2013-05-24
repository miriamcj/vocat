class Vocat.Views.Groups extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/groups"]

	events:
		'click [data-behavior="create-group"]': 'createGroup'
		'click [data-behavior="draggable-user"]': 'toggleSelect'


	initialize: (options)  ->
		if Vocat.Bootstrap.Collections.Group?
			@groups = new Vocat.Collections.Group(Vocat.Bootstrap.Collections.Group)
		if Vocat.Bootstrap.Collections.Creator?
			@creators = new Vocat.Collections.Creator(Vocat.Bootstrap.Collections.Creator)
		@render()

	createGroup: () ->
		name = @$el.find('[data-behavior="group-name"]').val()
		group = new Vocat.Models.Group({name: name})
		group.save()
		if group.validationError
			Vocat.Dispatcher.trigger('flash', {scope: 'groups', level: 'error', message: group.validationError})

	select: (element) ->
		$target = $(element)
		$target.addClass('selected')
		$target.attr('data-selected', 1)

	unselect: (element) ->
		$target = $(element)
		$target.removeClass('selected')
		$target.attr('data-selected', 0)

	toggleSelect: (e) ->
		target = $(e.currentTarget).find('.groups--owner')
		$target = $(target)
		$target.toggleClass('selected')
		if $target.hasClass('selected')
			$target.attr('data-selected', 1)
		else
			$target.attr('data-selected', 0)

	animateMove: (el, ui) ->
		el = $(el)
		targetOffset = ui.helper.offset()
#		el.offset(targetOffset)
		console.log targetOffset
		console.log targetOffset
#		el.animate(
#			{
#				postion: 'fixed'
#				top: ui.helper.offset().top
#				left: ui.helper.offset().left
#			},
#			'slow',
#			() ->
		ui.helper.find('.groups--owner').css({
			zIndex: 20
			position: 'absolute'
			border: '2px solid green'
		})
		el.appendTo(ui.helper)
		el.css({
			position: 'absolute'
			top: 0
			left: 0
			zIndex: 10
		})
		targetDegrees = @getRandomInt(0,30)
		increment = Math.ceil(targetDegrees / 100)
		console.log increment, targetDegrees
		el.animate(
			{  borderSpacing: -90 },
			{
				step: (now,fx) ->
					move = now * increment
					console.log move, increment
					$target = $(@)
					$target.css('-webkit-transform','rotate('+move+'deg)')
					$target.css('-moz-transform','rotate('+move+'deg)')
					$target.css('-ms-transform','rotate('+move+'deg)')
					$target.css('-o-transform','rotate('+move+'deg)')
					$target.css('transform','rotate('+move+'deg)')
				duration:'100'
			},
			'linear'
		)
#		el.animate(
#			{
#				transform: 'rotate('+ @getRandomInt(-30,30) + 'deg)'
#			}
#		)
#		)

	getRandomInt: (min, max) ->
		Math.floor(Math.random() * (max - min + 1)) + min

	cloneAndGroupSelectedIn: (ui) ->

		selected = @$el.find('[data-selected="1"]')

		alreadyCloned = ui.helper.find('.groups--owner')
		ignoreIds = []
		alreadyCloned.each (iteration, ownerElement) ->
			ignoreIds.push($(ownerElement).data().userId)

		selected.each (iteration, el) =>
			el = $(el)
			data = el.data()
			if !_.contains(ignoreIds, data.userId)
				clone = $(el).clone().removeAttr('id').attr('data-clone', 1)
				console.log clone
				el.append(clone)
				offset = $(el).offset()
				$(clone).offset(offset)
				@animateMove(clone, ui)

	maskElement: (el) ->
		$el = $(el)
		$el.fadeTo('medium', 0.33)

	unmaskElement: (el) ->
		$el = $(el)
		$el.fadeTo(0, 1)

	getOriginalFromClone: (clone) ->
		data = clone.data()
		original = $('#creator-' + data.userId)

	initDraggables: () ->
		@$el.find('[data-behavior="draggable-user"]').draggable({
#			revert: 'invalid'
			containment: 'document'
			helper: 'clone'
			cursor: 'move'
			start: (event, ui) =>
				ui.helper.find('.groups--owner').each (iteration, clone) =>
					ui.helper.css({border: '1px solid blue'})
					clone = $(clone)
					clone.attr('data-clone', 1)
					original = @getOriginalFromClone(clone)
					@maskElement(original)
					@select(clone)
					@select(original)
				@cloneAndGroupSelectedIn(ui)

			stop: (event, ui) =>
				ui.helper.find('.groups--owner').each (iteration, clone) =>
					clone = $(clone)
					original = @getOriginalFromClone(clone)
					@unselect(original)
					@unmaskElement(original)
		})

	initDroppables: () ->
#		@$el.find('[data-behavior="droppable-group"]').droppable({
#			drop: (e, ui) ->
#				droppedOn = $(@);
#				console.log @droppedOn.data()
#				$(ui.draggable).detach().css({top: 0,left: 0}).appendTo(droppedOn);
#		})
#
#
#	@$el.find('[data-behavior="droppable-user"]').droppable({
#		drop: (e, ui) ->
#			droppedOn = $(@);
#			console.log droppedOn
#			$(ui.draggable).detach().css({top: 0,left: 0}).appendTo(droppedOn);
#	})


	render: () ->
		context = {
			groups: @groups.toJSON()
			creators: @creators.toJSON()
		}
		@$el.html(@template(context))

		@initDraggables()
		@initDroppables()



