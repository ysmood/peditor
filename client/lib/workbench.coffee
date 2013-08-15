###

Take the charge of Peditor's row system.

###

class Workbench

	# ********** Public **********

	constructor: ->
		@$outline = $('#outline')

		@container_stack = []

		@init_grid_hover()

		console.log 'Workbench Loaded.'

	add_row: ->
		if @container_stack.length == 0
			return

		$container = _.last(@container_stack)

		$row = $('<div class="r"></div>')

		# Check the container or its parent has no column inside.
		no_column = $container.find('>[class|="c"]').length == 0
		p_no_column = $container.parent().find('>[class|="c"]').length == 0

		if $container.hasClass('before') and p_no_column
			$container.before($row)
		else if $container.hasClass('after') and p_no_column
			$container.after($row)
		else if no_column
			$container.append($row)
		else
			$.fn.msg_box({
				title: 'Warning',
				body: 'A container that has columns inside can\'t hold another row.' 
			})
			return		

		@container_hover($row)

	add_column: ->
		# Add a column to another column's left or right side.

	add_widgete: ($col) ->

	update_pos_guide: (e) ->
		if @container_stack.length == 0
			return

		# Get current container
		$cur_con = _.last(@container_stack)

		pos = $cur_con.offset()
		delta = {
			x: e.pageX - pos.left
			y: e.pageY - pos.top
		}
		con_height = $cur_con.height()
		con_width = $cur_con.width()

		$cur_con.removeClass('before after')
		if $cur_con.hasClass('r')
			if delta.y < con_height / 4
				$cur_con.addClass('before')
			else if delta.y > con_height * 3 / 4
				$cur_con.addClass('after')


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
		stack = @container_stack

		mouse_enter = ->
			stack.push $elem

			if stack.length > 1
				stack[stack.length - 2]
					.removeClass('hover')
					.removeClass('before after')

			$elem.addClass('hover')

		mouse_leave = ->
			if stack.length > 1
				stack[stack.length - 2].addClass('hover')

			$e = stack.pop()
			if $e
				$e.removeClass('hover').removeClass('before after')

		$elem.hover(mouse_enter, mouse_leave)


workbench = new Workbench
