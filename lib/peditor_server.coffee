###

The main server.

###

express = require 'express'
fs = require 'fs'
_ = require 'underscore'
consolidate = require 'consolidate'

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
		@app.engine('html', consolidate.underscore)
		@app.set('view engine', 'html')
		@app.set('views', 'client')

		# Expose the underscore to every view.
		@app.locals._ = _

		# For security reason, remote user shouldn't have 
		# access to the page source code.
		@app.get(/\/(.+)(\.jshtml)$/, (req, res) ->
			console.warn('404: ' + req.originalUrl)
			res.render('pages/404')
		)

	init_client: ->
		@app.use(express.static('bower_components'))
		@app.use(express.static('client'))

		@app.get('/', (req, res) =>
			@render('peditor', res)
		)

	init_routes: ->
		@app.use((req, res) =>
			console.warn('404: ' + req.originalUrl)
			res.status(404)
			@render('pages/404', res)
		)

	render: (path, res) ->
		# Render the page inside a frame page.

		@app.render(path, (err, html) =>
			@app.render(
				'pages/app_frame',
				{ body: html },
				(err, html) ->
					res.send(html)
			)			
		)


# ************ Exports ************

peditor_server = new Peditor_server

exports.peditor_server = peditor_server

exports.start = ->
	peditor_server.start()
