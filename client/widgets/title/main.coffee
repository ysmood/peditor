class PDT.widgets.Title extends PDT.Widget
	constructor: ->
		# Required interface.
		# Triggered when this widget class is loaded.

		@$prop_text = @$properties.find('.text')
		@$prop_size = @$properties.find('.size')
		@$prop_align = @$properties.find('.align')

		# Add event listeners.
		@$prop_text.change(@text_changed)
		@$prop_size.change(@size_changed)
		@$prop_align.change(@align_clicked)

	added: ($widget) ->
		# Required interface.
		# Triggered when a new widget is add to a container.
		# A widget specified initialization should be implemented here.
		# Such as js based animation for a widget.

	selected: ($widget) ->
		# Required interface.
		# Triggered when a widget is selected.

		$text = $widget.find('.text')
		$span = $widget.find('.text span')

		@$prop_text.val($span.text())
		@$prop_size.val($text.attr('class').match(/(h\d)/)[1])

		align = $text.css('text-align')
		if align == 'start'
			@$prop_align.find('.btn')
				.removeClass('active')
				.first().addClass('active')
		else
			@$prop_align.find('.btn').removeClass('active')
			@$prop_align.find("[value='#{align}']")
				.parent().addClass('active')

	text_changed: =>
		$span = @$get_selected().find('.text span')

		$span.text(@$prop_text.val())

		# Record the history for the 'undo & redo' operation.
		# It's the widget's responsibility to notify the Peditor
		# that the pdoc has changed.
		@rec('Title text changed')

	size_changed: =>
		$text = @$get_selected().find('.text')

		$text.removeClass().addClass('text ' + @$prop_size.val())

		@rec('Title size changed')

	align_clicked: =>
		$text = @$get_selected().find('.text')

		$text.css({
			'text-align': @$prop_align.find(':checked').val()
		})

		@rec('Title align changed')
