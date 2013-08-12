###

Take the charge of Peditor's row system.

###

class Workbench

	# ********** Public **********

	constructor: ->
		@$row = $('.row')
		@$row_guide = $('.row-guide')
		@$selection_area = $('.selection-area')

		@init_row_guide()

		console.log 'Workbench Loaded.'

	add_column: (sender) ->
		if sender then sender.disabled = true

		# This should be call first to make its children
		# have available width and height.
		@$row_guide.show()

		$.fn.dragging({
			data: {
				e_start: null,
				start_num: 0,
				end_num: 0,
				col_num: @$row_guide.columns.length,
				col_width: @$row_guide.columns[0].width(),
				row_guide_left: @$row_guide.offset().left
			},
			mouse_down: (e, data) =>
				data.e_start = e
				@$selection_area.show()
			,
			mouse_move: (e, data) =>
				# Find the right rect from the mouse trace.
				# Simple direction detection.
				left = _.min([e.pageX, data.e_start.pageX])
				top = _.min([e.pageY, data.e_start.pageY])
				width = Math.abs(e.pageX - data.e_start.pageX)
				height = Math.abs(e.pageY - data.e_start.pageY)
				
				@$selection_area.css({
					left: left,
					top: top,
					width: width,
					height: height
				})

				# Highlight columns that are in selection area.
				# Area detection, or collision detection.
				# Here width detection only, so not complex.
				data.start_num = Math.floor(
					(left - data.row_guide_left) / data.col_width
				)
				data.end_num = Math.ceil(
					(left + width - data.row_guide_left) / data.col_width
				)

				for i in [0 ... @$row_guide.columns.length]
					$col = @$row_guide.columns[i]

					if data.start_num <= i < data.end_num
						$col.addClass('col-selected')
					else
						$col.removeClass('col-selected')
			,
			mouse_up: (e, data) =>
			# After the mouseup, the add column action will be done, and
			# a new column holder should be added and ready to serve.

				# Add column holder
				if data.end_num != data.start_num			
					$column = $('<div class="col-holder">')
					$column.css({
						width: 100 / data.col_num * (data.end_num - data.start_num) + '%',
						marginLeft: 100 / data.col_num * data.start_num + '%'
					})

					@$row.append($column)

				# Clear
				@$selection_area.hide()
				@$selection_area.css({
					left: -10000,
					top: -10000
				})

				# Unhighlight the guide columns.
				for $col in @$row_guide.columns
					$col.removeClass('col-selected')

				@$row_guide.hide()

				sender.disabled = false
		})

	add_column_cancel: ->
		$(window).mouseup()

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


workbench = new Workbench

# This will sync the loading order.
loaded_evt = new CustomEvent(
	'workbench_loaded',
	{ "detail": workbench }
)
window.parent.dispatchEvent(loaded_evt)
