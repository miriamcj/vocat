submissionDetail = {
	init: ->
		Popcorn.player('baseplayer')
		pop = Popcorn('#ourvideo')

		pop.footnote({
			start: 0
			end: 2
			target: 'annotation-one'
			text: ''
			effect: 'applyclass'
			applyclass: 'active'
		})
		.footnote({
			start: 2
			end: 4
			target: 'annotation-two'
			text: ''
			effect: 'applyclass'
			applyclass: 'active'
		})
		.footnote({
			start: 4
			end: 6
			target: 'annotation-three'
			text: ''
			effect: 'applyclass'
			applyclass: 'active'
		})
}

$ ->
	submissionDetail.init()