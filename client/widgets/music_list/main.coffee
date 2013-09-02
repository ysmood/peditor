class PDT.widgets.Music_list extends PDT.Widget
	constructor: ->

		@$properties.find('.random').click(=>
			@added(@$get_selected())
		)

	added: ($widget) ->

		$.getJSON('/fake/music_list').done((list)->
			list_html = ''
			for i in list
				img = '/widgets/music_list/img/' + _.random(3) + '.jpg'
				html = "
					<div class='item'>
						<div class='num font-l font-20'>#{i.no}</div>
						<div class='img'>
							<img src='#{img}'>
						</div>
						<div class='info'>
							<div class='title'>#{i.title}</div>
							<div class='artist'>#{i.artist}</div>
						</div>
					</div>"
				list_html += html
			$widget.html(list_html)
		)

	selected: ($widget) ->

	get_doc: ($widget) ->
		$widget.html()
