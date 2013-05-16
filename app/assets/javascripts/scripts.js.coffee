# Typekit font events
try
  Typekit.load(
    active: ->
      # Vertically centers alert labels
      $('[data-behavior=alert]').each( ->
        alertHeight = $(@).outerHeight()
        alertTop = (alertHeight / 2) - 14;
        $(@).children('[data-behavior=alert-label]').css('top',alertTop)
      )
  )
catch e

# TODO remove redundancy
window.Vocat.Utility = {
	dropdown: {
		init: ->
			$toggle = $('[data-class=dropdown-toggle]')
			$dropdown = $('[data-class=dropdown]')
			$container = $('[data-class=dropdown-container]')
			$dropdown.each( ->
				containerHeight = $(@).parents('[data-class=dropdown-container]').outerHeight()
				$(@).css('top',containerHeight)
			)
			$(document).click( ->
				$container.removeClass('open')
			)
			$toggle.click((event) ->
				globalState = $container.hasClass('open')
				localState = $(@).parents().hasClass('open')
				if globalState == true
					$container.removeClass('open')
					event.stopPropagation()
				if localState == false
					event.stopPropagation()
				else
					$(@).parents('[data-class=dropdown-container]').toggleClass('open')
				$(@).parents('[data-class=dropdown-container]').toggleClass('open')
				event.preventDefault()
			)
	}

	stickyHeaders: {
		init: ->
			$('[data-behavior=sticky-header]').waypoint((direction) ->
				if direction == "down"
					$(@).addClass('stuck')
				if direction == "up"
					$(@).removeClass('stuck')
			)
	}

	# TODO temporary
	shortcutNav: {
		init: ->
			$('.js-shortcut-nav-toggle').click((event) ->
				$(@).toggleClass('active')
				$('.js-shortcut-nav').toggleClass('visible')
				event.preventDefault()
			)
	}

	# TODO :checked state should be persistent across pageloads
	helpOverlay: {
		init: ->
			$toggle = $('[data-behavior=help-overlay-toggle]')
			state = $toggle.is(':checked')
			if state == true
				$toggle.parents('label').addClass('active')
			$toggle.click( ->
				$(@).parents('label').toggleClass('active')
			)
	}

}

$ ->
	Vocat.Utility.dropdown.init()
	Vocat.Utility.stickyHeaders.init()
	Vocat.Utility.shortcutNav.init()
	Vocat.Utility.helpOverlay.init()
