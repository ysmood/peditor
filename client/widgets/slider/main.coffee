
class PDT.widgets.Slider extends PDT.Widget

	constructor: ->

	added: ($widget) ->
		# $('#slider').nivoSlider({
		# 	effect: 'sliceDown'
		# 	slices: 10
		# 	boxCols: 4
		# 	boxRows: 4
		# })

	selected: ($widget) ->

	get_doc: ($widget) ->
		@$orgin_widget.html()

