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

# shortcutNav = {
# 	init: ->
		
# }

$ ->
	chosen.init()