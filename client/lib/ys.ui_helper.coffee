###

UI helper

###

$.fn.dragging = (options) ->
	# options: object
	# 	$target: jQuery
	# 	data: any
	# 	mouse_down:  (e, data) ->
	# 	mouse_move:  (e, data) ->
	# 	mouse_up:  (e, data) ->

	mouse_down = (e) ->
		options.mouse_down(e, options.data)

		$(window).mousemove(mouse_move)
		$(window).mouseup(mouse_up)

	mouse_move = (e) ->
		options.mouse_move(e, options.data)

	mouse_up = (e)->
		options.mouse_up(e, options.data)

		# Release event resource.
		$(window).off('mousemove', mouse_move)
		$(window).off('mouseup', mouse_up)

	options.$target.mousedown(mouse_down)

$.fn.msg_box = (options) ->
	# options: object
	#	title: string
	#	body: string

	html = _.template('
		<div class="modal fade">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<%= title %>
					</div>
					<div class="modal-body">
						<%= body %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>',
		options
	)

	$modal = $(html)

	$modal.on('hidden.bs.modal', ->
		$modal.remove()
	)

	$modal.modal('show')
