# A helper to generate new widget.

do ->
	name = _.str.trim(
		location.pathname.replace('widget_editor', '')
		'/'
	)

	url = '/widgets/' + name + '/index.html'

	$.ajax(url).done((html) ->
		$html = $(html)

		$doc_js = $html.find('script[PDT-widget]')
		$js = $doc_js.clone()
		$doc_js.remove()

		$('#main').append($html)

		count = 0
		$js.each(->
			$.fn.load_js(this.src, '#scripts', ($new_js) ->
				$new_js.attr('PDT-widget', name)
				if ++count == $js.length
					init()
			)
		)
	)

	init = ->
		name = _.str.capitalize(name)

		if not _.has(PDT.widgets, name)
			first = _.keys(PDT.widgets)[0]
			$.fn.msg_box({
				title: "Error"
				body: "
					Widget class name should be <b>#{name}</b>,
					not <b>#{first}</b>.<br>
					Please double check your js file.
				"
			})
			return

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

		$('.PDT-info').delay(1000 * 5).slideUp()

