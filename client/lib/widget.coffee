
setTimeout(
	->
		widgets.$current_widget = $('.widget')
	1000
)

for k, w of widgets
	w.$properties = $('.properties')

	w.find = (select_string) ->
		w.$properties.find(select_string)

	w.init()
