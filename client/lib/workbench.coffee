###

Take the charge of Peditor's row system.

###

class Workbench

	# ********** Public **********

	constructor: ->		
		@$outline = $('#outline')

		@grid_mouse_on_stack = []

		@init_grid_hover()

		console.log 'Workbench Loaded.'

	add_row: ->
		$container = _.last(@grid_mouse_on_stack)

		if not $container then return

		if $container.find('>[class|="c"]').length > 0
			$.fn.msg_box({
				title: 'Warning',
				body: 'A container that has columns inside can\'t hold another row.' 
			})
			return

		$row = $('<div class="r"></div>')

		$container.append($row)

		@container_hover($row)

	add_column: ->
		# Add a column to another column's left or right side.

		$new_col = $("<div class=\"c-#{size}\"></div>")

	add_widgete: ($col) ->

	# ********** Private **********

	init_grid_hover: ->
		$containers = @$outline.find('.r, [class|="c"]')
		$containers.push @$outline[0]

		for elem in $containers
			@container_hover(elem)

	container_hover: (elem) ->
		# When entering a child box, the parent effect will be removed,
		# When leaving a child box, the parent effect will be recovered.
		# In this situation a stack is used to trace the behavior.
		
		$elem = if elem instanceof $ then elem else $(elem)
		stack = @grid_mouse_on_stack

		mouse_enter = ->
			stack.push $elem

			if stack.length > 1
				stack[stack.length - 2].removeClass('hover')

			$elem.addClass('hover')

		mouse_leave = ->
			if stack.length > 1
				stack[stack.length - 2].addClass('hover')

			$e = stack.pop()
			if $e then $e.removeClass('hover')

		$elem.hover(mouse_enter, mouse_leave)


workbench = new Workbench
