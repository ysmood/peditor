###

The Peditor client application.

Aug 2013, ys

###


class Peditor

	# ********** Public **********

	constructor: ->
		@$cur_decoration = $('#cur_decoration')

		@init_add_row_btn()

		console.log 'Peditor loaded.'

	init_add_row_btn: ->
		$.fn.dragging({
			$target: $('#add_row_btn')
			data: {

			},
			mouse_down: (e, data) =>
				@$cur_decoration.show()
				@$cur_decoration.html('<i class="icon-align-justify font-20"></i>')

				# Prevent the default text selection area.
				e.preventDefault()
			,
			mouse_move: (e, data) =>
				@$cur_decoration.css({
					left: e.pageX,
					top: e.pageY
				})

				# The positioning guide will help indicate which side to 
				# insert the new container.
				workbench.update_pos_guide(e)
			,
			mouse_up: (e, data) =>
				workbench.add_row()

				@$cur_decoration.removeAttr('style').hide()
			,
		})

	# ********** Private **********


peditor = new Peditor
