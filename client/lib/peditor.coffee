###

The Peditor client application.

Aug 2013, ys

###


class Peditor

	# ********** Public **********

	constructor: ->
		@$cur_decoration = $('#cur_decoration')

		@init_ui_components()
		
		@init_container_tools()

		console.log 'Peditor loaded.'

	init_container_tools: ->
		for btn in $('.btn_container')
			@init_container_btn($(btn))


	# ********** Private **********
	
	init_ui_components: ->
		# Init all bootstrap tooltips.
		$('[title]').tooltip()

	init_container_btn: ($btn) ->
		type = $btn.attr('peditor-type')
		$.fn.dragging({
			$target: $btn
			mouse_down: (e) =>
				@show_cur_decoration(type)

				# Prevent the default text selection area.
				e.preventDefault()
			,
			mouse_move: (e) =>
				@$cur_decoration.css({
					left: e.pageX,
					top: e.pageY
				})

				# The positioning guide will help indicate which side to 
				# insert the new container.
				workbench.update_pos_guide(e, type)
			,
			mouse_up: (e) =>
				@exe_command(type)

				@hide_cur_decoration()
		})

	exe_command: (type) ->
		switch type
			when 'row'
				workbench.add_row()

			when 'column'
				workbench.add_column(
					$('.column-width').val()
				)

			when 'delete'
				workbench.del_container()

	show_cur_decoration: (type) ->
		# Choose the corresponding dragging icon.
		
		@$cur_decoration.show()

		switch type
			when 'row'
				@$cur_decoration.html('<i class="icon-align-justify font-20"></i>')

			when 'column'
				@$cur_decoration.html('<i class="icon-columns font-20"></i>')

			when 'delete'
				@$cur_decoration.html('<i class="icon-trash font-20"></i>')


	hide_cur_decoration: ->
		@$cur_decoration.removeAttr('style').hide()

peditor = new Peditor
