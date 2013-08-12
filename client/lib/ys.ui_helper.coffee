###

UI helper

###

$.fn.dragging = (options) ->
	mouse_down = (e) ->
		options.mouse_down(e, options.data)

		$(window).mousemove(mouse_move)

		# Prevent the default text selection area.
		e.preventDefault()

	mouse_move = (e) ->
		options.mouse_move(e, options.data)

	mouse_up = (e)->
		options.mouse_up(e, options.data)

		# Release event resource.
		$(window).unbind('mousedown', mouse_down)
		$(window).unbind('mousemove', mouse_move)
		$(window).unbind('mouseup', mouse_up)

	$(window).mousedown(mouse_down)
	$(window).mouseup(mouse_up)