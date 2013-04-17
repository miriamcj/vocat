chosen = {
	init: ->
		select = $('.js-select')
		select.chosen(
			disable_search: true
		)
		select.each( ->
			selectClass = $(@).attr('class')
			$(@).siblings('.chzn-container').removeAttr('style').attr('class', selectClass)
		)
}

pageHeader = {
	init: ->
		$('.js-page-header').waypoint((direction) ->
			if direction == "down"
				$(@).addClass('stuck')
			if direction == "up"
				$(@).removeClass('stuck')
		)
}

# TODO temporary
shortcutNav = {
	init: ->
		$('.js-shortcut-nav-toggle').click((event) ->
			$(@).toggleClass('active')
			$('.js-shortcut-nav').toggleClass('open')
			event.preventDefault()
		)
}

$ ->
	chosen.init()
	pageHeader.init()
	shortcutNav.init()