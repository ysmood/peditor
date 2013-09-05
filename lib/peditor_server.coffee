###

The main server.

###

express = require 'express'
request = require 'request'
consolidate = require 'consolidate'
_ = require 'underscore'
faker = require 'Faker'

fs = require 'fs'

config = require '../../config.json'

class Peditor_server
	constructor: ->
		@app = express()

		@init_db()

		# The middleware to parse the body of POST request.
		@app.use(express.bodyParser())

		@init_view_engine()

		@init_client()

		@init_routes()

	start: ->
		@app.listen(config.port)

	init_db: ->
		@db_url = "http://127.0.0.1:#{config.db_port}/peditor"

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

		@app.get('/', @render_client)
		@app.get('/pdoc/:id/:rev?', @render_client)

	init_routes: ->
		@widget_editor()

		@save()
		@get()

		if config.mode == 'development'
			@test()
			@fake()

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

	widget_editor: ->
		# A helper page to create new widget.
		# New widget page should be located in the 'client/widget/'.

		@app.get('/widget_editor/:name', (req, res) =>
			@render_sections(
				['head', 'foot'],
				(htmls) =>
					_.extend(res.locals, htmls)
					res.render('widget_editor')
			)
		)

	render_client: (req, res) =>
		widgets_path = 'client/widgets/'
		list = fs.readdirSync(widgets_path)
		widget_list = []

		for i in list
			if fs.lstatSync(widgets_path + i).isDirectory()
				if i != 'template'
					widget_list.push i

		@app.locals.widget_list = widget_list

		@render_sections(
			[
				'head'
				'navbar'
				'workbench'
				'workpannel'
				'help'
				'about'
				'foot'
			],
			(htmls) =>
				_.extend(res.locals, htmls)
				res.render('peditor')
		)

	test: ->
		@app.get('/test', (req, res) =>
			@render_sections(
				['head', 'foot'],
				(htmls) =>
					_.extend(res.locals, htmls)
					res.render('test')
			)
		)

	save: ->
		@app.post('/save/:id?', (req, res) =>
			delete req.body.__proto__
			id = req.params.id

			# If has a id, then update the exist pdoc,
			# else create a new one.
			if id
				request.put({
					url: @db_url + '/' + id
					body: req.body
					json: true
				}, (err, rres, body) ->
					if err
						res.status(500)
						res.send(err)
					else
						res.send(body)
				)
			else
				delete req.body._revisions
				request.post({
						url: @db_url
						body: req.body
						json: true
				}, (err, rres, body) ->
					if err
						res.status(500)
						res.send(err)
					else
						res.send(body)
				)
		)

	get: ->
		@app.get('/get/:id/:rev?', (req, res) =>
			id = req.params.id
			rev = req.params.rev

			# if rev specified, get the revision,
			# else get the lastest revision.
			if rev
				path = "/#{id}?rev=#{rev}"
			else
				path = '/' + id + '?revs=true'

			# First get all the full versin list.
			# This can't be done by step operation?
			request.get(
				@db_url + '/' + id + '?revs=true',
				(err, rres, body) =>
					if err
						res.status(500)
						res.send(err)
					else
						revs = JSON.parse(body)._revisions

						# Then get the specific version.
						request.get(
							@db_url + path,
							(err, rres, body) ->
								if err
									res.status(500)
									res.send(err)
								else
									body = JSON.parse(body)
									body._revisions = revs
									res.send(body)
						)
			)
		)

	fake: ->
		# For test project only.

		@app.get('/fake/music_list', (req, res) ->
			list = []
			for i in [1 .. 30]
				item = {
					no: i
					title: faker.Lorem.words().join(' ')
					artist: faker.Name.findName()
					album: faker.Lorem.words().join(' ')
				}
				list.push item

			res.send list
		)

# ************ Exports ************

peditor_server = new Peditor_server

exports.peditor_server = peditor_server

exports.start = ->
	peditor_server.start()
