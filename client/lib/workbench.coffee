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

		@add_column()

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

	add_column: ->
		e_start = null

		mouse_down = (e) =>
			e_start = e
			@$selection_area.show()
			@$window.mousemove(mouse_move)

			# Prevent the default text selection area.
			e.preventDefault()

		mouse_move = (e) =>
			# Find the right rect from the mouse trace.
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

		mouse_up = =>
			@$selection_area.hide()
			@$selection_area.css({
				left: -10000,
				top: -10000
			})
			@$window.unbind('mousemove', mouse_move)

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
		for i in [0 ... col_num]
			$col = $('<div class="col">')
			$col.css({
				width: width
			})
			
			@$grid_guide.append($col)


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

