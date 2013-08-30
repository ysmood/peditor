
class PDT.widgets.Slider extends PDT.Widget

	constructor: ->
		@slider_count = 0

	added: ($widget) ->
		$slider = $widget.find('.carousel.slide')

		id = 'slider-' + @slider_count++

		$slider.attr('id', id)
		$slider.find('.carousel-indicators li').attr('data-target', '#' + id)
		$slider.find('[data-slide]').attr('href', '#' + id)

		$slider.carousel({
			interval: 3000
		})

	selected: ($widget) ->

