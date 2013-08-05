###

The main server.

###

express = require 'express'

config = require '../config.json'

class Peditor_server
	constructor: ->
		@app = express()

		@init_view_engine()

		@init_client()

		@init_routes()

	start: ->
		console.log "Peditor server start on port " + config.port
		@app.listen(config.port)

	init_view_engine: ->
		@app.engine('jshtml', require('jshtml-express'))
		@app.set('view engine', 'jshtml')
		@app.set('views', 'client')

	init_client: ->
		@app.use(express.static('bower_components'))
		@app.use(express.static('client'))
		
		@app.get('/', (req, res) ->
			res.render('index')
		)

	init_routes: ->
		@app.use((req, res) ->
			res.render('404')
		)



peditor_server = new Peditor_server

exports.peditor_server = peditor_server

exports.start = ->
	peditor_server.start()
