widgets.title = {
	init: ->
		@$prop_text = @$properties.find('.text')
		@$prop_size = @$properties.find('.size')

		@$prop_text.change(=>
			$text = widgets.$selected.find('.text')

			$text.text(@$prop_text.val())
		)

		@$prop_size.change(=>
			$text = widgets.$selected.find('.text')

			$text.removeClass().addClass('text ' + @$prop_size.val())
		)

	selected: ($widget) ->
		$text = $widget.find('.text')

		@$prop_text.val($text.text())
		@$prop_size.val($text.attr('class').match(/(h\d)/)[1])
}