###

The Peditor client application.

Aug 2013, ys

###


class Peditor

	# ********** Public **********

	constructor: () ->
		@init_grid_width_input()

		@init_cancel_manager()

		task_stack = []

		console.log 'Peditor loaded.'

	# ********** Private **********

	init_grid_width_input: =>
		$input = $('#grid_width_input')

		$input.change(=>
			val = $input.val()
			ys.workbench.set_grid_wdith(val)
		)

	init_cancel_manager: ->
		Mousetrap.bind(
			'esc',
			->
				console.log('escape')
			,
			'keyup'
		)

	add_col_clicked: ->

# To sync the loading order.
addEventListener('workbench_loaded', (e) ->
	ys.workbench = e.detail
	ys.peditor = new Peditor
)
