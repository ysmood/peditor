# A helper to generate new widget.

do ->
	name = _.keys(widgets)[0]

	widgets[name]::$properties = $('.properties')
	widget = new widgets[name]


	$('.widget').after($('.widget').clone())

	$('.widget').each(->
		$this = $(this)
		widget.added($this)
	)

	$('.widget').click(->
		$this = $(this)
		$selected = widgets.$selected

		if $selected
			$selected.removeClass('selected')

		$this.addClass('selected')

		widgets.$selected = $this

		widget.selected($this)
	)

	$('.widget:first').click()

	$('[title]').tooltip({
		placement: "auto"
	})
