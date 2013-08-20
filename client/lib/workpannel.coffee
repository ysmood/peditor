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
		$groups = $('.properties .group')

		type = workbench.container_type($elem)

		$indicator = $('.selected-con-i')
		$indicator.show().text(type)

		for g in $groups
			$g = $(g)
			if _.contains(
				$g.attr('peditor-bind').split(/\s+/),
				type
			)
				$g.show()
				
				@bind_property($g, $elem)
			else
				$g.hide()

	bind_property: ($g, $elem) ->
		$ps = $g.find('[peditor-css]')

		# Get the value.
		$ps.each(->
			$p = $(@)
			c = $p.attr('peditor-css')

			switch c
				when 'background-image'
					v = $elem.css('backgound-image')
					if v
						$p.val(
							v.match(/url\((.*)\)/)[1]
						)
					else
						$p.val('')

				when 'col-width'
					$p.val($elem.attr('w'))

				else
					$p.val($elem.css(c))
		)

		# Set the value.
		$ps.off().change(->
			$p = $(@)
			c = $p.attr('peditor-css')
			v = $p.val()

			switch c
				when 'background-image'
					v = "url(#{v})"
					$elem.css(c, v)

				when 'col-width'
					$elem.attr('w', v)

				else
					$elem.css(c, v)
		)

		
	properties_deactive: ($elem) ->
		$indicator = $('.selected-con-i')
		$indicator.hide()

		$('.properties .group').hide()

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
					$('.containers .column-width').val()
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
