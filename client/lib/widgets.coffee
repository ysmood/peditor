# A helper to generate new widget.
do ->
	name = _.keys(widgets)[0]
	widget = widgets[name]
	widget.$properties = $('.properties')
	widget.init()

	$('.widget').click(->
		$this = $(this)
		$selected = widgets.$selected

		if $selected
			$selected.removeClass('selected')

		$this.addClass('selected')

		widgets.$selected = $this

		widget.selected($this)
	)
