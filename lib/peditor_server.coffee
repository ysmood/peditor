###

The main server.

###

express = require 'express'
fs = require 'fs'

config = require '../config.json'

class Peditor_server
	constructor: ->
		@app = express()

		@init_view_engine()

		@init_client()

		@init_routes()

	start: ->
		@app.listen(config.port)

	init_view_engine: ->
		@app.engine('jshtml', require('jshtml-express'))
		@app.set('view engine', 'jshtml')
		@app.set('views', 'client')

		# For security reason, remote user shouldn't have 
		# access to the page source code.
		@app.get(/\/(.+)(\.jshtml)$/, (req, res) ->
			jshtml_path = req.params[0]
			res.render(jshtml_path)
		)

	init_client: ->
		@app.use(express.static('bower_components'))
		@app.use(express.static('client'))

	init_routes: ->
		@app.use((req, res) ->
			console.warn('404: ' + req.originalUrl)
			res.render('404')
		)


# ************ Exports ************

peditor_server = new Peditor_server

exports.peditor_server = peditor_server

exports.start = ->
	peditor_server.start()
