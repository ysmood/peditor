class PDT.Widget

	# Your widget's property pannel object.
	# Will be init by the Workpanel.
	$properties: null

	# An orgin clone of the widget's jQuery object.
	$widget: null

	# Record the history for the 'undo & redo' operation.
	# It's the widget's responsibility to notify the Peditor
	# that the pdoc has changed.
	rec: ->
		# Native code ...

	# Current selected widget. Return a jQuery object.
	$get_selected: ->
		PDT.widgets.$selected
