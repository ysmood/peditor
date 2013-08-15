###

UI helper

###

$.fn.report_compatibility = ->
	# Here will list all html5 tech used in project.
	# If the report is not empty, alert a report.

	report = ''
	if not Modernizr.boxsizing
		report += "CSS box-sizing not supported.<br>"

	if not Modernizr.css_calc
		report += "CSS calc not supported.<br>"

	if report
		$.fn.msg_box({
			title: '<div class="alert alert-danger">Compatibility issue</div>',
			body: report		
		})
	else
		console.log "Compatibility: all supported."

Modernizr.addTest("boxsizing", ->
    return Modernizr.testAllProps("boxSizing") and
    (document.documentMode == undefined or document.documentMode > 7)
)

Modernizr.addTest('css_calc', ->
	prop = 'width:'
	value = 'calc(10px);'
	el = document.createElement('div')

	el.style.cssText = prop + Modernizr._prefixes.join(value + prop)

	return !!el.style.length
)

$.fn.dragging = (options) ->
	# options: object
	# 	$target: jQuery
	# 	data: any
	# 	mouse_down:  (e, data) ->
	# 	mouse_move:  (e, data) ->
	# 	mouse_up:  (e, data) ->

	mouse_down = (e) ->
		e.target = options.target
		e.data = options.data
		options.mouse_down(e)

		$(window).mousemove(mouse_move)
		$(window).mouseup(mouse_up)

	mouse_move = (e) ->
		e.target = options.target
		e.data = options.data
		options.mouse_move(e)

	mouse_up = (e)->
		e.target = options.target
		e.data = options.data
		options.mouse_up(e)

		# Release event resource.
		$(window).off('mousemove', mouse_move)
		$(window).off('mouseup', mouse_up)

	options.$target.mousedown(mouse_down)

$.fn.msg_box = (options) ->
	# options: object
	#	title: html
	#	body: html

	html = _.template('
		<div class="modal fade">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header font-l font-26">
						<%= title %>
					</div>
					<div class="modal-body font-n font-16">
						<%= body %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>',
		options
	)

	$modal = $(html)

	$modal.on('hidden.bs.modal', ->
		$modal.remove()
	)

	$modal.modal('show')


$.fn.report_compatibility()
