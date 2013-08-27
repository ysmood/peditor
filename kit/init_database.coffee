request = require 'request'

config = require '../config.json'

db_url = "http://127.0.0.1:#{config.db_port}/peditor"

request.del(
	db_url,
	(err, res, body) ->
		if err
			console.error err
)

request.put(
	db_url,
	(err, res, body) ->
		if err
			console.error err
)
