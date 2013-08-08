###

The Peditor client application.

Aug 2013, ys

###


class Peditor

	# ********** Public **********

	constructor: () ->
		@init_grid_width_input()

		console.log 'Peditor loaded.'

	# ********** Private **********

	init_grid_width_input: =>
		$input = $('#grid_width_input')

		$input.change(=>
			val = $input.val()
			ys.workbench.set_grid_wdith(val)
		)

# To sync the loading order.
addEventListener('workbench_loaded', (e) ->
	ys.workbench = e.detail
	ys.peditor = new Peditor
)
