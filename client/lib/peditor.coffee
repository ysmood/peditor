###

The Peditor client application.

Aug 2013, ys

###


class Peditor
	constructor: ->
		@init_grid_width_input()

	init_grid_width_input: ->
		$input = $('#grid_width_input')

		$input.change(->
			val = $input.val()
			ys.workbench.set_grid_wdith(val)
		)

ys.peditor = new Peditor
