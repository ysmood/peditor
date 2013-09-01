
class PDT.widgets.Slider extends PDT.Widget

	constructor: ->
		self = this
		@$properties.find('[img]').each(->
			$this = $(this)
			$this.change(->
				$widget = self.$get_selected()
				n = $this.attr('img')
				$data = $widget.find("[img='#{n}']")
				$data.attr('src', $this.val())
				self.added($widget)
			)
		)

	added: ($widget) ->

		$wrap = $('<div class="slider-wrapper theme-default">')
		$nivo = $('<div class="nivoSlider"></div>')

		$data = $widget.find('data')
		$data.each((i) ->
			$this = $(this)
			src = $this.attr('src')
			$img = $("<img src='#{src}' data-thumb='#{src}'>")
			$nivo.append($img)
		)

		$widget.find('.slider-wrapper').remove()

		$wrap.append($nivo)
		$widget.append($wrap)

		$nivo.nivoSlider({
			effect: 'sliceDown'
			slices: 10
			boxCols: 4
			boxRows: 4
		})

	selected: ($widget) ->
		self = this
		@$properties.find('[img]').each(->
			$this = $(this)
			n = $this.attr('img')
			$widget = self.$get_selected()
			$this.val($widget.find("[img='#{n}']").attr('src'))
		)


	get_doc: ($widget) ->
		$doc = $widget.clone()
		$doc.find('.slider-wrapper').remove()
		$doc.html()

