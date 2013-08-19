###

The Peditor client application.

Aug 2013, ys

###


class Workpannel

	# ********** Public **********

	constructor: ->
		@$cur_decoration = $('#cur_decoration')
		
		@init_container_tools()

		console.log 'Workpannel loaded.'

	init_container_tools: ->
		for btn in $('.btn_container, .btn_widget')
			@init_container_btn($(btn))

	properties_active: ($elem) ->
		type = workbench.container_type($elem)

		$indicator = $('.selected-con-i')
		$indicator.show().text(type)

		# switch type
		# 	when 'root'

		# 	when 'row'

		# 	when 'column'

		# 	when 'widget'
		

	properties_deactive: ($elem) ->
		$indicator = $('.selected-con-i')
		$indicator.hide()

	# ********** Private **********

	init_container_btn: ($btn) ->
		$.fn.dragging({
			$target: $btn
			data: {
				type: $btn.attr('peditor-type')
			}
			mouse_down: (e) =>
				@show_cur_decoration(e)

				# Prevent the default text selection area.
				e.preventDefault()

			mouse_move: (e) =>
				@$cur_decoration.css({
					left: e.pageX,
					top: e.pageY
				})

				# The positioning guide will help indicate which side to 
				# insert the new container.
				workbench.update_pos_guide(e)

			mouse_up: (e) =>
				@exe_command(e)

				@hide_cur_decoration()
		})		

	exe_command: (e) ->
		switch e.data.type
			when 'row'
				workbench.add_row(e)

			when 'column'
				workbench.add_column(e,
					$('.column-width').val()
				)

			when 'delete'
				workbench.del_container(e)

			when 'widget'
				workbench.add_widget(e)

	show_cur_decoration: (e) ->
		# Hide the selected container animation.
		# Choose the corresponding dragging icon.
		
		if workbench.$selected_con
			workbench.$selected_con.removeClass('selected')
		
		@$cur_decoration.show()

		switch e.data.type
			when 'row'
				@$cur_decoration.html('<i class="icon-reorder font-24"></i>')

			when 'column'
				@$cur_decoration.html('<i class="icon-trello font-24"></i>')

			when 'delete'
				@$cur_decoration.html('<i class="icon-trash font-24"></i>')

			when 'widget'
				@$cur_decoration.html('<i class="icon-gear font-24"></i>')

	hide_cur_decoration: ->
		# Recover the selected container animation.
		if workbench.$selected_con
			workbench.$selected_con.addClass('selected')

		@$cur_decoration.removeAttr('style').hide()


workpannel = new Workpannel
