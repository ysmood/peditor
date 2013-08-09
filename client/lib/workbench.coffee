###

Take the charge of Peditor's grid system.

###

class Workbench

	# ********** Public **********

	constructor: ->
		@$window = $(window)

		@$grid = $('.grid')
		@$grid_guide = $('.grid-guide')
		@$selection_area = $('.selection-area')

		@init_grid_guide()

		console.log 'Workbench Loaded.'

		# @add_col_holder()

	set_grid_wdith: (width) ->
		@$grid.css({
			width: width
		})

		# Check whether the unit is percentage or px.
		if width.indexOf('%') > -1
			margin_left =
				-parseInt(width.replace('%', '')) / 2 + '%'
		else
			margin_left = -parseInt(width) / 2

		@$grid_guide.css({
			width: width,
			left: '50%'
			marginLeft: margin_left
		})

	add_col_holder: (sender) ->
		if sender then sender.disabled = true

		# This should be call first to make its children
		# have available width and height.
		@$grid_guide.show()

		col_num = @$grid_guide.columns.length
		col_width = @$grid_guide.columns[0].width()
		grid_guide_left = @$grid_guide.offset().left		

		e_start = null
		mouse_down = (e) =>
			e_start = e

			@$selection_area.show()
			@$window.mousemove(mouse_move)

			# Prevent the default text selection area.
			e.preventDefault()

		start_num = end_num = 0
		mouse_move = (e) =>
			# Find the right rect from the mouse trace.
			# Simple direction detection.
			left = _.min([e.pageX, e_start.pageX])
			top = _.min([e.pageY, e_start.pageY])
			width = Math.abs(e.pageX - e_start.pageX)
			height = Math.abs(e.pageY - e_start.pageY)
			
			@$selection_area.css({
				left: left,
				top: top,
				width: width,
				height: height
			})

			# Highlight columns that are in selection area.
			# Area detection, or collision detection.
			# Here width detection only, so not complex.
			start_num = Math.floor(
				(left - grid_guide_left) / col_width
			)
			end_num = Math.ceil(
				(left + width - grid_guide_left) / col_width
			)

			for i in [0 ... @$grid_guide.columns.length]
				$col = @$grid_guide.columns[i]

				if start_num <= i < end_num
					$col.addClass('col-selected')
				else
					$col.removeClass('col-selected')

		# After the mouseup, the add column action will be done, and
		# a new column holder should be added and ready to serve.
		mouse_up = =>
			# Add column holder
			$col_holder = $('<div class="col-holder">')
			$col_holder.css({
				width: 100 / col_num * (end_num - start_num) + '%',
				marginLeft: 100 / col_num * start_num + '%'
			})

			@$grid.append($col_holder)

			# Clear
			@$selection_area.hide()
			@$selection_area.css({
				left: -10000,
				top: -10000
			})

			# Release event resource.
			@$window.unbind('mousedown', mouse_down)
			@$window.unbind('mousemove', mouse_move)
			@$window.unbind('mouseup', mouse_up)

			# Unhighlight the guide columns.
			for $col in @$grid_guide.columns
				$col.removeClass('col-selected')

			@$grid_guide.hide()

			sender.disabled = false

		@$window.mousedown(mouse_down)
		@$window.mouseup(mouse_up)


	# ********** Private **********

	init_grid_guide: ->
		col_num = parseInt(
			@$grid_guide.attr('data-col-num')
		)
		width = (100 / col_num) + '%'

		# Add columns to grid guide.
		@$grid_guide.empty()
		columns = []
		for i in [0 ... col_num]
			$col = $('<div class="col">')
			$col.css({
				width: width
			})
			
			@$grid_guide.append($col)
			columns.push $col

		@$grid_guide.columns = columns

		@$grid_guide.hide()


if window.parent.ys
	workbench = new Workbench

	# This will sync the loading order.
	loaded_evt = new CustomEvent(
		'workbench_loaded',
		{ "detail": workbench }
	)
	window.parent.dispatchEvent(loaded_evt)
else
	workbench = new Workbench

