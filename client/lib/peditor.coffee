###

The Peditor client application.

Aug 2013, ys

###


class Peditor

	# ********** Public **********

	constructor: () ->
		@$workspace = $('.workspace')
		@$workbench = $('.workbench')
		@$workpanel = $('.workpanel')

		console.log 'Peditor loaded.'

	# ********** Private **********


# To sync the loading order.
addEventListener('workbench_loaded', (e) ->
	ys.workbench = e.detail
	ys.peditor = new Peditor
)
