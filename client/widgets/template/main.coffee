# Peditor.Widget class is in the 'client/lib/widget.coffee' file.
# Read it for more api details.
class widget.Template extends Peditor.Widget

	# Required interface.
	# Triggered when this widget class is loaded.
	constructor: ->

	# Required interface.
	# Triggered when a new widget is add to a container.
	# A widget specified initialization should be implemented here.
	# Such as widget's js based animation.
	added: ($widget) ->

	# Required interface.
	# Triggered when a widget is selected.
	selected: ($widget) ->

