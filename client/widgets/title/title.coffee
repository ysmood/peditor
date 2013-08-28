widgets.title = {
	init: ->
		# Triggered when this widget class is loaded.

		@$prop_text = @$properties.find('.text')
		@$prop_size = @$properties.find('.size')

		@$prop_text.change(=>
			$span = widgets.$selected.find('.text span')

			$span.text(@$prop_text.val())

			# Record the history for the 'undo & redo' operation.
			@rec()
		)

		@$prop_size.change(=>
			$text = widgets.$selected.find('.text')

			$text.removeClass().addClass('text ' + @$prop_size.val())

			@rec()
		)

		console.log 'Widget: Title loaded.'

	added: ($widget) ->
		# Triggered when a new widget is add to a container.
		# A widget specified initialization should be implemented here.
		# Such as widget's js based animation.

		$icon = $widget.find('i')
		op = 0.8
		v = 0.01
		animate = ->
			$icon.css('opacity', op)

			if op >= 1 or op <= 0.5
				v *= -1
			op += v

			requestAnimationFrame(animate)

		requestAnimationFrame(animate)

	selected: ($widget) ->
		# Triggered when a widget is selected.

		$text = $widget.find('.text')
		$span = $widget.find('.text span')

		@$prop_text.val($span.text())
		@$prop_size.val($text.attr('class').match(/(h\d)/)[1])
}