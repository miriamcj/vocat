#= require ./abstract

class Vocat.Views.AbstractModalView extends Vocat.Views.AbstractView

	initialize: (options) ->
		super(options)

	centerModal: () ->
		yOffset = $(document).scrollTop()
		xOffset = $(document).scrollLeft()
		yCenter = $(window).height() / 2
		xCenter = $(window).width() / 2
		yPosition = yCenter - (@$el.find('.js-modal').outerHeight() / 2)
		xPosition = xCenter - (@$el.find('.js-modal').outerWidth() / 2)
		@$el.prependTo('body')
		@$el.css({
			position: 'absolute'
			zIndex: 300
			left: (xPosition + xOffset) + 'px'
			top: (yPosition + yOffset) + 'px'
		})

	resizeBackdrop: () ->
		@ensureBackdrop().css({
			height: $(document).height()
		})

	ensureBackdrop: () ->
		backdrop = $('#js-modal-backdrop')
		if backdrop.length == 0
			backdrop = $('<div id="js-modal-backdrop">').css({
				 position: "absolute"
				 top: 0
				 left: 0
				 height: $(document).height()
				 width: "100%"
				 opacity: 0.5
				 backgroundColor: "#000"
				 "z-index": 200
			}).appendTo($('body')).hide()
			$(window).bind('resize', _.bind(@resizeBackdrop, @))
		backdrop

	showBackdrop: () ->
		@resizeBackdrop()
		@ensureBackdrop().fadeIn(250)

	showModal: () ->
		@showBackdrop()
		@centerModal()

	hideModal: () ->
		@ensureBackdrop().fadeOut(250)