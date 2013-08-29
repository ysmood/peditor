# A helper to generate new widget.

do ->
	name = _.keys(PDT.widgets)[0]

	PDT.widgets[name]::$properties = $('.properties')
	widget = new PDT.widgets[name]


	$('.widget').after($('.widget').clone())

	$('.widget').each(->
		$this = $(this)
		widget.added($this)
	)

	$('.widget').click(->
		$this = $(this)
		$selected = PDT.widgets.$selected

		if $selected
			$selected.removeClass('selected')

		$this.addClass('selected')

		PDT.widgets.$selected = $this

		widget.selected($this)
	)

	$('.widget:first').click()

	$('[title]').tooltip({
		placement: "auto"
	})
