###

Take the charge of Peditor's row system.

###

class Workbench

	# ********** Public **********

	constructor: (
		@grid_size = 12
		@guide_threshold = 20
	) ->
		@$root = $('#outline')

		@init_containers()

		console.log 'Workbench Loaded.'

	add_row: (e) ->
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

	add_column: (e, width = 3) ->
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
				(sum, elem) =>
					return sum + @get_col_size($(elem))
				,sum
			)
		else if type == 'column'
			sum = _.reduce(
				$con.parent().find('>.c'),
				(sum, elem) =>
					return sum + @get_col_size($(elem))
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
		switch type
			when 'row'
				if $con.find('.r').length > 0
					$.fn.msg_box({
						title: '<div class="alert">Warning</div>'
						body: 'A container that has row inside can\'t hold another column.'
					})
					return
				else
					$con.append($col)

			when 'column'
				if $con.hasClass('before')
					$con.before($col)
				else
					$con.after($col)			

			when 'root'
				$.fn.msg_box({
					title: '<div class="alert">Warning</div>'
					body: 'The root can\'t directly hold a column.'
				})
			
			else
				return

		@init_container($col)

	add_widget: (e) ->
		if not @$current_container
			return
		
		$widget = @new_widget(e.$target)

		$con = @$current_container

		switch @container_type($con)
			when 'widget'
				if $con.hasClass('before')
					$con.before($widget)
				else
					$con.after($widget)

			when 'column'
				# Copy all content of widget into the column.
				$con.append($widget)

			else
				$.fn.msg_box({
					title: '<div class="alert">Warning</div>'
					body: 'Only column can contain widget.' 
				})
				return

		@init_container($widget)

	del_container: (e) ->
		if not @$current_container
			return
		if @container_type(@$current_container) == 'root'
			return

		@$current_container.remove()

	update_pos_guide: (e) ->
		if not @$current_container
			return

		# Get current container
		$con = @$current_container

		type = e.data.type

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

			when 'widget'
				if delta.y < @guide_threshold
					$con.addClass('before')
				else if delta.y > con_height - @guide_threshold
					$con.addClass('after')

	update_col_height: ($col) ->
		# To make the columns that in the same tree depth
		# have the same height.
		

	# ********** Private **********

	init_containers: ->
		$containers = @$root.find('.r, .c, .widget')
		$containers.push @$root[0]

		for elem in $containers
			@init_container(elem)

	init_container: (elem) ->
		# This method will init the hover and the selected effects.
		
		$elem = if elem instanceof $ then elem else $(elem)

		mouse_over = (e) =>
			$elem.addClass('hover')
			@$current_container = $elem

			e.stopPropagation()

		mouse_out = (e) =>
			$elem.removeClass('hover').removeClass('before after')
			@$current_container = null

			e.stopPropagation()

		clicked = (e) =>
			if $elem == @$selected_con
				if $elem.hasClass('selected')
					$elem.removeClass('selected')
				else
					$elem.addClass('selected')
			else
				if @$selected_con
					@$selected_con.removeClass('selected')
				$elem.addClass('selected')
			
			if $elem.hasClass('selected')
				@$selected_con = $elem

				# Active properties editing.
				workpannel.properties_active($elem)
			else
				workpannel.properties_deactive($elem)
				@$selected_con = null

			e.stopPropagation()

		$elem
			.mouseover(mouse_over)
			.mouseout(mouse_out)
			.click(clicked)

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

	new_widget: ($target) ->
		$widget = $('<div>').addClass('widget')

		# TODO: Get the widgets from the database.
		switch $target.attr('peditor-widget')
			when 'rocket'
				$widget.html('<div style="height: 200px; background: #aeffc1">rocket</div>')
				
			when 'music'
				$widget.html('<div style="height: 300px; background: #d0ffa8">music</div>')

		return $widget

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
				when 'widget'
					return 'widget'
				when 'root'
					return 'root'

		return null


workbench = new Workbench
