###

The Peditor client application.

Aug 2013, ys

###


class Peditor

	# ********** Public **********

	constructor: ->
		console.log 'Peditor loaded.'

		@init_grid_hover_effect()

	init_grid_hover_effect: ->
		# When entering a child box, the parent effect will be removed,
		# When leaving a child box, the parent effect will be recovered.
		# In this situation a stack is used to trace the behavior.
		
		$containers = $('#outline').find('.r, [class|="c"]')
		stack = []

		mouse_enter = (e) ->
			$elem = $(@)
			stack.push $elem

			if stack.length > 1
				stack[stack.length - 2].removeClass('hover')

			$elem.addClass('hover')

		mouse_leave = (e) ->
			if stack.length > 1
				stack[stack.length - 2].addClass('hover')

			$elem = stack.pop()
			if $elem
				$elem.removeClass('hover')

		$containers
			.off('mouseenter')
			.off('mouse_leave')
			.mouseenter(mouse_enter)
			.mouseleave(mouse_leave)

	# ********** Private **********


peditor = new Peditor
