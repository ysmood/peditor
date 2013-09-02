
class PDT.widgets.Text extends PDT.Widget

	constructor: ->
		@$prop = @$properties.find('.text')
		self = this
		@$prop.keyup(->
			self.$get_selected().find('.editable').html(
				self.$prop.val()
			)
		)

	selected: ($widget) ->
		@$prop.val($widget.find('.editable').html())
