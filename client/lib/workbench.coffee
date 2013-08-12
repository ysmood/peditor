###

Take the charge of Peditor's row system.

###

class Workbench

	# ********** Public **********

	constructor: ->
		@$window = $(window)

		@$row = $('.row')
		@$row_guide = $('.row-guide')
		@$selection_area = $('.selection-area')

		@init_row_guide()

		console.log 'Workbench Loaded.'

	add_col_holder: (sender) ->
		if sender then sender.disabled = true

		# This should be call first to make its children
		# have available width and height.
		@$row_guide.show()

		col_num = @$row_guide.columns.length
		col_width = @$row_guide.columns[0].width()
		row_guide_left = @$row_guide.offset().left		

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
				(left - row_guide_left) / col_width
			)
			end_num = Math.ceil(
				(left + width - row_guide_left) / col_width
			)

			for i in [0 ... @$row_guide.columns.length]
				$col = @$row_guide.columns[i]

				if start_num <= i < end_num
					$col.addClass('col-selected')
				else
					$col.removeClass('col-selected')

		# After the mouseup, the add column action will be done, and
		# a new column holder should be added and ready to serve.
		mouse_up = =>
			# Add column holder
			if end_num != start_num			
				$col_holder = $('<div class="col-holder">')
				$col_holder.css({
					width: 100 / col_num * (end_num - start_num) + '%',
					marginLeft: 100 / col_num * start_num + '%'
				})

				@$row.append($col_holder)

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
			for $col in @$row_guide.columns
				$col.removeClass('col-selected')

			@$row_guide.hide()

			sender.disabled = false			

		@$window.mousedown(mouse_down)
		@$window.mouseup(mouse_up)

	add_col_holder_cancel: ->
		@$window.mouseup()

	# ********** Private **********

	init_row_guide: ->
		col_num = parseInt(
			@$row_guide.attr('data-col-num')
		)
		width = (100 / col_num) + '%'

		# Add columns to row guide.
		@$row_guide.empty()
		columns = []
		for i in [0 ... col_num]
			$col = $('<div class="col">')
			$col.css({
				width: width
			})
			
			@$row_guide.append($col)
			columns.push $col

		@$row_guide.columns = columns

		@$row_guide.hide()


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
