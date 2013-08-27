###

The main server.

###

express = require 'express'
fs = require 'fs'
_ = require 'underscore'
consolidate = require 'consolidate'

config = require '../../config.json'

class Peditor_server
	constructor: ->
		@app = express()

		@init_view_engine()

		@init_client()

		@init_widget()

		@init_test()

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

		# Auto render all the html files.
		@app.get(/\/(.+)(?:\.html)$/, (req, res) =>
			res.render(req.params[0])
		)

		@app.get('/', (req, res) =>
			@render_sections(
				[
					'head'
					'navbar'
					'workbench'
					'workpannel'
					'foot'
				],
				(htmls) =>
					_.extend(res.locals, htmls)
					res.render('peditor')
			)
		)

	init_widget: ->
		# A helper page to create new widget.
		# New widget page should be located in the 'client/widget/'.

		@app.get('/widgets/:name', (req, res) =>
			@render_sections(
				['head', 'foot'],
				(htmls) =>
					_.extend(res.locals, htmls)

					path = 'widgets/' + req.params.name + '/index.html'

					if not fs.existsSync('client/' + path)
						@render_404(req, res)
						return

					@app.render(
						path,
						(err, html) =>
							res.locals.widget = html
							res.render('widgets')
					)
			)
		)

	init_test: ->
		@app.get('/test', (req, res) =>
			@render_sections(
				['head', 'foot'],
				(htmls) =>
					_.extend(res.locals, htmls)
					res.render('test')
			)
		)

	init_routes: ->
		@app.use(@render_404)

	render_404: (req, res) =>
		console.warn('404: ' + req.originalUrl)
		res.status(404)

		@render_sections(['head'],
			(htmls) =>
				_.extend(res.locals, htmls)
				res.render('404')
		)

	render_sections: (pages, done, htmls = {}) ->
		# Render pages in a sequence.

		if _.isEmpty(pages)
			done(htmls)
			return

		path = pages.pop()

		@app.render('sections/' + path, (err, html) =>
			htmls[path] = html

			@render_sections(pages, done, htmls)
		)


# ************ Exports ************

peditor_server = new Peditor_server

exports.peditor_server = peditor_server

exports.start = ->
	peditor_server.start()
