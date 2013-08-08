###

Take the charge of Peditor's grid system.

###

class Workbench
	constructor: ->
		@$window = $(window)

		@$grid = $('.grid')
		@$grid_guide = $('.grid-guide')

		@init_grid_guide()

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

	set_grid_wdith: (width) ->
		@$grid.css({
			width: width
		})

		# Check whether the unit is percentage or px.
		if width.indexOf('%') > -1
			margin_left =
				-parseInt(width.replace('%', '')) / 2 + '%'
		else
			margin_left = -width / 2

		@$grid_guide.css({
			width: width,
			left: '50%'
			marginLeft: margin_left
		})

window.parent.ys.workbench = new Workbench
