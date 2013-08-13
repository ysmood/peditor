###

Take the charge of Peditor's row system.

###

class Workbench

	# ********** Public **********

	constructor: ->
		@$outline = $('#outline')

		console.log 'Workbench Loaded.'

	add_row: ($parent, is_append = true) ->
		# Add grid into a specified container.

		$row = $('<div class="row"></div>')

		if is_append	
			$parent.append($row)
		else
			$parent.prepend($row)

	add_column: ($col, $, is_right = true) ->
		# Add a column to another column's left or right side.

		$row = $('<div class="row"></div>')

		if is_append	
			$parent.append($row)
		else
			$parent.prepend($row)

	add_widgete: ($col) ->

	# ********** Private **********

	init_row_guide: ->


workbench = new Workbench
