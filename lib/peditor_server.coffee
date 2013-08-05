###

The main server.

###

express = require 'express'

config = require '../config.json'

class Peditor_server
	constructor: ->
		@app = express()

		@init_client()

		@init_routes()

	start: ->
		console.log "Peditor server start on port " + config.port
		@app.listen(config.port)

	init_routes: ->
		@app.use((req, res) ->
			res.sendfile('client/404.html')
		)

	init_client: ->
		@app.use(express.static('bower_components'))
		@app.use(express.static('client'))


peditor_server = new Peditor_server

exports.peditor_server = peditor_server

exports.start = ->
	peditor_server.start()
