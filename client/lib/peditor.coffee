###

The Peditor client application.

Aug 2013, ys

###


class Peditor

	# ********** Public **********

	constructor: ->
		@init_ui_components()

		console.log 'Peditor loaded.'

	# ********** Private **********

	init_ui_components: ->
		# Init all bootstrap tooltips.
		$('[title]').tooltip({
			placement: "auto"
		})

peditor = new Peditor
