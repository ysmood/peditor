# A helper to generate new widget.

do ->
	name = _.keys(widgets)[0]
	widget = widgets[name]
	widget.$properties = $('.properties')
	widget.rec = -> null
	widget.init()

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
