###

The Peditor client application.

Aug 2013, ys

###


class PDT.Workpanel

	# ********** Public **********

	constructor: ->
		@load_widgets()

		@$cur_decoration = $('#cur_decoration')

		@init_container_tools()

		console.log 'Workpanel loaded.'

	init_container_tools: ->
		for btn in $('.btn_container, .btn_widget')
			@init_container_btn($(btn))

		$('#workpanel .containers .column-width').val(6)

	edit_active: ($elem) =>
		type = PDT.workbench.container_type($elem)

		$indicator = $('.selected-con-i')
		$indicator.show().text(type)

		# Show the current container's editable properties.
		$groups = $('#workpanel [peditor-bind]')
			.hide()
			.filter("[peditor-bind~='#{type}']")
			.show()
		$('#workpanel .properties').hide()

		for g in $groups
			@edit_bind($(g), $elem)

		if type == 'widget'
			PDT.widgets.$selected = PDT.workbench.$selected_con
			name = PDT.widgets.$selected.attr('peditor-widget')
			PDT.widgets[name].$properties.show()
			PDT.widgets[name].selected(PDT.widgets.$selected)

		# Scrolling to the actived properties.
		$.fn.scroll_to({
			parent: $('#workpanel')
			to: $('#properties')
		})

	edit_deactive: ($elem) ->
		$indicator = $('.selected-con-i')
		$indicator.hide()

		if PDT.workbench.$selected_con
			PDT.workbench.$selected_con.removeClass('selected')
			PDT.workbench.$selected_con = null

		$('#properties [peditor-bind], #properties .properties').hide()

	# ********** Private **********

	edit_bind: ($g, $elem) ->
		$ps = $g.find('[peditor-bind-prop]')

		# Display the current value.
		$ps.each(->
			$p = $(@)
			c = $p.attr('peditor-bind-prop')

			switch c
				when 'background-image'
					m = $elem.css(c).match(/url\((.+)\)/)
					$p.val(if m then m[1])

				when 'column-width'
					$p.val($elem.attr('w'))

				else
					$p.val($elem.css(c))
		)

		# Set the value.
		$ps.off().change(->
			$p = $(@)
			c = $p.attr('peditor-bind-prop')
			v = $p.val()

			switch c
				when 'background-image'
					$elem.css(c, "url(#{v})")

				when 'column-width'
					$elem.attr('w', v)

				else
					$elem.css(c, v)
		)

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
				PDT.workbench.update_pos_guide(e)

			mouse_up: (e) =>
				@exe_command(e)

				@hide_cur_decoration()
		})

	exe_command: (e) ->
		switch e.data.type
			when 'row'
				PDT.workbench.add_row(e)

			when 'column'
				PDT.workbench.add_column(e,
					$('.containers .column-width').val()
				)

			when 'delete'
				PDT.workbench.del_container(e)

			when 'widget'
				PDT.workbench.add_widget(e)

		PDT.peditor.rec('container')

	show_cur_decoration: (e) ->
		# Hide the selected container animation.
		# Choose the corresponding dragging icon.

		if PDT.workbench.$selected_con
			PDT.workbench.$selected_con.removeClass('selected')

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
		if PDT.workbench.$selected_con
			PDT.workbench.$selected_con.addClass('selected')

		@$cur_decoration.removeAttr('style').hide()

	load_widgets: ->
		count = 0
		$btn_widgets = $('[peditor-widget-btn]')
		$btn_widgets.each(->
			$this = $(this)
			name = $this.attr('peditor-widget-btn')

			url = '/widgets/' + name + '/index.html'

			$.ajax(url).done((html) ->
				$html = $(html)

				# Extract each part of a editable widget.
				$thumb = $html.find('.thumb')
				$props = $html.find('.properties')
				$widget = $html.find('.widget:first')
				$css = $html.find('link')
				$js = $html.find('script')

				# Hide the properties
				$props.hide()

				# Inject all the parts into the app.
				$this.append($thumb)
				$('#properties').append($props)
				$('body').append($css)

				# Attach the $widget to the button.
				$this.data('widget', $widget)

				# We need to use the native way to create the script element,
				# or the browser will not excute the script.
				js = document.createElement("script")
				js.type = "text/javascript"
				js.src = $js[0].src
				$('body')[0].appendChild(js)
				js.onload = ->
					# Init the widget interface.
					class_name = _.str.titleize(name)
					w_class = PDT.widgets[class_name]
					w_class::$properties = $props
					w_class::rec = PDT.peditor.rec
					widget = new w_class
					PDT.widgets[name] = widget

					console.log "Widget: #{name} loaded."

					count++

					if count == $btn_widgets.length
						console.log 'All widgets loaded.'

						$('#peditor').trigger('widgets_loaded')
			)
		)


PDT.workpanel = new PDT.Workpanel
