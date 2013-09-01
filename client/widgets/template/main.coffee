# Peditor.Widget class is in the 'client/lib/widget.coffee' file.
# Read it for more api details.

# The prefix of 'PDT.widgets' is required.
# Class name's first letter should be capitalized.
class PDT.widgets.Template extends PDT.Widget

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

	# Get the pdoc of current widget.
	# Remove all the temporary doms here.
	# Return pure html.
	get_doc: ($widget) ->

