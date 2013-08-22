###

The controller of the server. Similar with apachectl.

###

spawn = require('child_process').spawn
fs = require 'fs'

config = require '../../config.json'

exec = (cmd, args) ->
	spawn(cmd, args, { stdio: 'inherit' })

save_runtime_info = (app) ->
	# Save the runtime info into a json file.
	# Such as stopping the server by the PID later.

	info = {
		pid: app.pid
	}
	fs.writeFileSync(
		'.runtime_info',
		JSON.stringify(info)
	)

start_server = ->
	# If in production mode, output all info into log files.
	if config.mode == 'development'
		app = exec('node', ['--debug', 'js/app.js'])
	else
		app = spawn('node', ['js/app.js'])
		app.stdout.on('data', (data) ->
			fs.appendFile('log/std.log', data)
		)
		app.stderr.on('data', (data) ->
			fs.appendFile('log/err.log', data)
		)

	save_runtime_info(app)

	console.log "Peditor start on " + config.port

stop_server = ->
	data = fs.readFileSync('.runtime_info')
	info = JSON.parse(data)

	exec('kill', [info.pid])

	console.log "Peditor stopped."


switch process.argv[2]
	when 'start'
		start_server()

	when 'stop'
		stop_server()

	else
		console.error 'You should enter a command!'
