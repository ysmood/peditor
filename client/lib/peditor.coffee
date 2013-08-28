###

The Peditor client application.

Aug 2013, ys

###


class Peditor

	# ********** Public **********

	constructor: ->
		@init_ui_components()

		@init_key_control()

		console.log 'Peditor loaded.'

	# ********** Private **********

	init_ui_components: ->
		# Init all bootstrap tooltips.
		$('[title]').tooltip({
			placement: "auto"
		})

	btn_save_clicked: (btn) ->
		$.ajax({
			type: "POST"
			url: '/save'
			data: {
				pdoc: $('#workbench').html()
			}
			dataType: "json"
		}).done((data) ->
			if data.ok
				$.fn.push_state({
					obj: 'pdoc'
					url: '/pdoc/' + data.id
				})
		)

	init_key_control: ->
		Mousetrap.bind('esc', ->
			if workbench.$selected_con
				workpanel.properties_deactive()
		)

peditor = new Peditor
