###

The Peditor client application.

Aug 2013, ys

###


class Peditor.Workpanel

	# ********** Public **********

	constructor: ->
		@load_widgets()

		@$cur_decoration = $('#cur_decoration')

		@init_container_tools()

		console.log 'Workpanel loaded.'

	init_container_tools: ->
		for btn in $('.btn_container, .btn_widget')
			@init_container_btn($(btn))

	properties_active: ($elem) =>
		$groups = $('#properties .group')

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

		if type == 'widget'
			widgets.$selected = workbench.$selected_con
			name = widgets.$selected.attr('peditor-widget')
			widgets[name].$properties.show()
			widgets[name].selected(widgets.$selected)


		$.fn.scroll_to({
			parent: $('#workpanel')
			to: $('#properties')
		})

	bind_property: ($g, $elem) ->
		$ps = $g.find('[peditor-css]')

		# Get the value.
		$ps.each(->
			$p = $(@)
			c = $p.attr('peditor-css')
			$p.val($elem.data(c))
		)

		# Set the value.
		$ps.off().change(->
			$p = $(@)
			c = $p.attr('peditor-css')
			v = $p.val()

			# Store the property data.
			$elem.data(c, v)
			switch c
				when 'background-image'
					$elem.css(c, "url(#{v})")

				when 'column-width'
					$elem.attr('w', v)

				else
					$elem.css(c, v)
		)

	properties_deactive: ($elem) ->
		$indicator = $('.selected-con-i')
		$indicator.hide()

		if workbench.$selected_con
			workbench.$selected_con.removeClass('selected')
			workbench.$selected_con = null

		$('#properties .group, .properties').hide()

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

		peditor.rec('container')

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

	load_widgets: ->
		$('[peditor-widget-btn]').each(->
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
					w_class = widgets[class_name]
					w_class::$properties = $props
					w_class::rec = peditor.rec
					widget = new w_class
					widgets[name] = widget

					$('#workbench [peditor-widget="title"]').each(->
						widgets[name].added($(this))
					)

					console.log "Widget: #{name} loaded."
			)
		)


workpanel = new Peditor.Workpanel
