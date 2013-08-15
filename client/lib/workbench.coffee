###

Take the charge of Peditor's row system.

###

class Workbench

	# ********** Public **********

	constructor: (@grid_size = 12) ->
		@$outline = $('#outline')

		@container_stack = []

		@init_grid_hover()

		console.log 'Workbench Loaded.'

	add_row: ->
		if @container_stack.length == 0
			return

		# Current container
		$con = _.last(@container_stack)

		$row = @new_row()

		# Check the container or its parent has no column inside.
		no_column = $con.find('>[class|="c"]').length == 0
		p_no_column = $con.parent().find('>[class|="c"]').length == 0

		if $con.hasClass('before') and p_no_column
			$con.before($row)
		else if $con.hasClass('after') and p_no_column
			$con.after($row)
		else if no_column
			$con.append($row)
		else
			$.fn.msg_box({
				title: '<div class="alert">Warning</div>'
				body: 'A container that has columns inside can\'t hold another row.' 
			})
			return		

		@init_container($row)

	add_column: (width = 3) ->
		# Add a column to another column's left or right side.
		
		if @container_stack.length == 0
			return

		# Current container
		$con = _.last(@container_stack)

		$col = @new_column(width)

		# In one row the sum of all columns' width must less than the grid size.
		# The default grid size is 12.
		type = $con.attr('peditor-type')
		sum = @get_col_size($col)
		if type == 'row'
			sum = _.reduce(
				$con.find('>[class|="c"]'),
				(sum, e) =>
					return sum + @get_col_size($(e))
				,sum
			)
		else if type == 'column'
			sum = _.reduce(
				$con.parent().find('>[class|="c"]'),
				(sum, e) =>
					return sum + @get_col_size($(e))
				,sum
			)

		if (
			$con.hasClass('before') or
			$con.hasClass('after') or
			type == 'row'
		) and sum > @grid_size
			$.fn.msg_box({
				title: '<div class="alert">Warning</div>'
				body: 'The sum of all columns\' width must less than the grid size.'
			})
			return		

		# A column can't hold another column.
		# Therefore, a column should be directly insdie a row.
		# The root can't directly hold a column.
		if type == 'row'
			$con.append($col)
		else if type == 'column' and $con.hasClass('before')
			$con.before($col)
		else if type == 'column' and $con.hasClass('after')
			$con.after($col)
		else if type == 'column'
			$.fn.msg_box({
				title: '<div class="alert">Warning</div>'
				body: 'A column can\'t hold another column'
			})
			return
		else
			$.fn.msg_box({
				title: '<div class="alert">Warning</div>'
				body: 'The root can\'t directly hold a column.'
			})
			return


		@init_container($col)

	add_widgete: ($col) ->

	update_pos_guide: (e, type) ->
		if @container_stack.length == 0
			return

		# Get current container
		$cur_con = _.last(@container_stack)

		# Only the same type will trigger the display of the guide.
		if $cur_con.attr('peditor-type') != type
			return

		pos = $cur_con.offset()
		delta = {
			x: e.pageX - pos.left
			y: e.pageY - pos.top
		}
		con_height = $cur_con.height()
		con_width = $cur_con.width()

		$cur_con.removeClass('before after')
		switch type
			when 'row'
				if delta.y < con_height / 4
					$cur_con.addClass('before')
				else if delta.y > con_height * 3 / 4
					$cur_con.addClass('after')

			when 'column'
				if delta.x < con_width / 4
					$cur_con.addClass('before')
				else if delta.x > con_width * 3 / 4
					$cur_con.addClass('after')


	# ********** Private **********

	init_grid_hover: ->
		$containers = @$outline.find('.r, [class|="c"]')
		$containers.push @$outline[0]

		for elem in $containers
			@init_container(elem)

	init_container: (elem) ->
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

	new_row: (width) ->
		$row = $('<div>')
			.attr('peditor-type', 'row')
			.addClass('r')
		return $row

	new_column: (width) ->
		$col = $('<div>')
			.attr('peditor-type', 'column')
			.addClass("c-#{width}")
		return $col

	get_col_size: ($col) ->
		return parseInt(
			$col.attr('class').match(/c-(\d+)/)[1]
		)

workbench = new Workbench
