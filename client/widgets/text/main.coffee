
class PDT.widgets.Text extends PDT.Widget

	constructor: ->
		$prop = @$properties.find('.text')
		self = this
		$prop.keyup(->
			self.$get_selected().find('.editable').html(
				$prop.val()
			)
		)

	added: ($widget) ->

	selected: ($widget) ->


	get_doc: ($widget) ->
		$widget.html()

