class PDT.Widget

	# ********************** Interface **********************
	# This part are the required methods that you should implement.
	# They are all behave like events.

	# Triggered when this widget class is loaded.
	constructor: ->

	# Triggered when a new widget is add to a container.
	# A widget specified initialization should be implemented here.
	# Such as widget's js based animation.
	added: ($widget) ->

	# Triggered when a widget is selected.
	selected: ($widget) ->

	# Get the pdoc of current widget.
	# Remove all the temporary doms here.
	# Return pure html.
	get_doc: ($widget) ->
		$widget.html()


	# ********************** Protected **********************
	# This part is the api that Peditor gives you to call.
	# Never overwrite them.

	# Your widget's property pannel object.
	# Will be init by the Workpanel.
	$properties: ->

	# An orgin clone of the widget's jQuery object.
	$widget: ->

	# Record the history for the 'undo & redo' operation.
	# It's the widget's responsibility to notify the Peditor
	# that the pdoc has changed.
	rec: ->

	# Current selected widget. Return a jQuery object.
	$get_selected: ->
		PDT.widgets.$selected
