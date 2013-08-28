###

The Peditor client application.

Aug 2013, ys

###


class Peditor

	# ********** Public **********

	constructor: ->
		@init_ui_components()

		@init_key_control()

		@init_history()

		console.log 'Peditor loaded.'

	# ********** Private **********

	init_ui_components: ->
		# Init all bootstrap tooltips.
		$('[title]').tooltip({
			placement: "auto"
		})

	init_history: ->
		# The edit history stack.
		@history = []

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

	btn_undo_clicked: (btn) ->


	btn_redo_clicked: (btn) ->

	btn_help_clicked: (btn) ->
		$.fn.msg_box({
			title: 'Help'
			body: $('#help').html()
		})

	init_key_control: ->
		Mousetrap.bind('ctrl+d', ->
			if workbench.$selected_con
				workpanel.properties_deactive()
		)

peditor = new Peditor
