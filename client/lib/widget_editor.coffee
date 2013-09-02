# A helper to generate new widget.

do ->
	name = _.str.trim(
		location.pathname.replace('widget_editor', '')
		'/'
	)

	url = '/widgets/' + name + '/index.html'

	$.ajax(url).done((html) ->
		$html = $(html)

		$html.find('[PDT-widget]').attr('PDT-widget', name)

		$doc_css = $html.find('link[PDT-widget], style[PDT-widget]')
		$css = $doc_css.clone()
		$doc_css.remove()

		$doc_js = $html.find('script[PDT-widget]')
		$js = $doc_js.clone()
		$doc_js.remove()

		$('#main').append($html)

		$css.each(->
			$.fn.load_css(this, '#scripts')
		)

		count = 0
		if $js.length
			$js.each(->
				$.fn.load_js(this, '#scripts', ($new_js) ->
					$new_js.attr('PDT-widget', name)
					if ++count == $js.length
						init()
				)
			)
		else
			init()
	)

	init = ->
		name = _.str.capitalize(name)

		first = _.keys(PDT.widgets)[0]
		if first == undefined
			class PDT.widgets[name] extends PDT.Widget

		if not _.has(PDT.widgets, name)
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
		PDT.widgets[name.toLowerCase()] = widget

		if location.search.indexOf('one') == -1
			$('.widget').after($('.widget').clone())

		$('.widget').each(->
			$this = $(this)
			widget.added($this)
		)

		$('.widget').click((e) ->
			$this = $(this)
			$selected = PDT.widgets.$selected

			if $selected
				$selected.removeClass('selected')

			$this.addClass('selected')

			PDT.widgets.$selected = $this

			widget.selected($this)

			e.stopPropagation()
		)

		$('.widget:first').click()

		$('[title]').tooltip({
			placement: "auto"
		})
