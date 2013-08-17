###

Take the charge of Peditor's row system.

###

class Workbench

	# ********** Public **********

	constructor: (
		@grid_size = 12
		@guide_threshold = 20
	) ->
		@$outline = $('#outline')

		@init_grid_hover()

		console.log 'Workbench Loaded.'

	add_row: ->
		if not @$current_container
			return

		# Current container
		$con = @$current_container

		$row = @new_row()

		# Check the container or its parent has no column inside.
		no_column = $con.find('>.c').length == 0
		p_no_column = $con.parent().find('>.c').length == 0

		if $con.hasClass('before') and p_no_column
			$con.before($row)
		else if $con.hasClass('after') and p_no_column
			$con.after($row)
		else if no_column
			$con.append($row)
		else
			$.fn.msg_box({
				title: '<div class="alert">Warning</div>'
				body: 'A container that has column inside can\'t hold another row.' 
			})
			return		

		@init_container($row)

	add_column: (width = 3) ->
		# Add a column to another column's left or right side.
		
		if not @$current_container
			return

		# Current container
		$con = @$current_container

		$col = @new_column(width)

		# In one row the sum of all columns' width must less than the grid size.
		# The default grid size is 12.
		type = @container_type($con)
		sum = @get_col_size($col)
		if type == 'row'
			sum = _.reduce(
				$con.find('>.c'),
				(sum, e) =>
					return sum + @get_col_size($(e))
				,sum
			)
		else if type == 'column'
			sum = _.reduce(
				$con.parent().find('>.c'),
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
		# A column and a row can't be sibling nodes.
		# Therefore, a column should be directly insdie a row.
		# The root can't directly hold a column.
		if type == 'row'
			if $con.find('.r').length > 0
				$.fn.msg_box({
					title: '<div class="alert">Warning</div>'
					body: 'A container that has row inside can\'t hold another column.'
				})
				return
			else
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

	add_widgete: ->

	del_container: ->
		if not @$current_container
			return

		@$current_container.remove()

	update_pos_guide: (e, type) ->
		if not @$current_container
			return

		# Get current container
		$con = @$current_container

		# Only the same type will trigger the display of the guide.
		if @container_type($con) != type
			return

		pos = $con.offset()
		delta = {
			x: e.pageX - pos.left
			y: e.pageY - pos.top
		}
		con_height = $con.height()
		con_width = $con.width()

		$con.removeClass('before after')
		switch type
			when 'row'
				if delta.y < @guide_threshold
					$con.addClass('before')
				else if delta.y > con_height - @guide_threshold
					$con.addClass('after')

			when 'column'
				if delta.x < @guide_threshold
					$con.addClass('before')
				else if delta.x > con_width - @guide_threshold
					$con.addClass('after')

	update_col_height: ($col) ->
		# To make the columns that in the same tree depth
		# have the same height.
		
		$col.parent().find()


	# ********** Private **********

	init_grid_hover: ->
		$containers = @$outline.find('.r, .c')
		$containers.push @$outline[0]

		for elem in $containers
			@init_container(elem)

	init_container: (elem) ->
		# When entering a child box, the parent effect will be removed,
		# When leaving a child box, the parent effect will be recovered.
		# In this situation a stack is used to trace the behavior.
		
		$elem = if elem instanceof $ then elem else $(elem)

		mouse_over = (e) =>
			$elem.addClass('hover')
			@$current_container = $elem

			e.stopPropagation()

		mouse_out = (e) =>
			$elem.removeClass('hover').removeClass('before after')
			@$current_container = null

			e.stopPropagation()

		$elem.mouseover(mouse_over).mouseout(mouse_out)

	new_row: (width) ->
		$row = $('<div>').addClass('r add_animate').one(
			'animationend webkitAnimationEnd MSAnimationEnd oAnimationEnd',
			->
				$row.removeClass('add_animate')
		)
		return $row

	new_column: (width) ->
		$col = $('<div>').addClass("c w-#{width} add_animate").one(
			'animationend webkitAnimationEnd MSAnimationEnd oAnimationEnd',
			->
				$col.removeClass('add_animate')
		)
		return $col

	get_col_size: ($col) ->
		return parseInt(
			$col.attr('class').match(/w-(\d+)/)[1]
		)

	container_type: ($con) ->
		list = $con.attr('class').split(/\s+/)

		for i in list
			switch i
				when 'r'
					return 'row'
				when 'c'
					return 'column'

		return null


workbench = new Workbench
