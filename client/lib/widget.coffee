# A helper to generate new widget.

# Simulate the async widget loading.
setTimeout(
	->
		widgets.$current_widget = $('.widget')
	1000
)

for k, w of widgets
	w.$properties = $('.properties')

	w.init()
