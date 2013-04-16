chosen = {
	init: ->
		$('.select').chosen(
			disable_search: true
		)
		$('.select').each( ->
			selectClass = $(@).attr('class')
			$(@).siblings('.chzn-container').removeAttr('style').attr('class', selectClass)
		)
}

# TODO temporary
shortcutNav = {
	init: ->
		$('[data-class=shortcut-nav-toggle]').click((event) ->
			$(@).toggleClass('active')
			$('[data-class=shortcut-nav]').toggleClass('open')
			event.preventDefault()
		)
}

$ ->
	chosen.init()
	shortcutNav.init()