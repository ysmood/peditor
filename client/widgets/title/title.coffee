widgets.title = {
	init: ->
		$prop_text = this.$properties.find('.text')
		$prop_size = this.$properties.find('.size')

		$prop_text.change(->
			$text = widgets.$current_widget.find('.text')

			$text.text($prop_text.val())
		)

		$prop_size.change(->
			$text = widgets.$current_widget.find('.text')

			$text.removeClass().addClass('text ' + $prop_size.val())
		)
}