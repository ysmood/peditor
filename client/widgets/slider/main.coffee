
class PDT.widgets.Slider extends PDT.Widget

	constructor: ->

	added: ($widget) ->
		$('#slider').nivoSlider()

	selected: ($widget) ->

	get_doc: ($widget) ->
		@$widget.html()

