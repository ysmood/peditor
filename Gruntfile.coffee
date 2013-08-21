# The server app's coffeescripts that will be compiled.
server_coffee = [
	'app'
	'kit/server_ctl'
	'lib/peditor_server'
]
server_coffee_list = {}
for c in server_coffee
	server_coffee_list["dist/#{c}.js"] = c + '.coffee'


# The client app's coffeescripts that will be compiled.
client_coffee = [
	'peditor'
	'ui_helper'
	'workbench'
	'workpannel'
]
client_coffee_list = {}
for c in client_coffee
	client_coffee_list["client/js/#{c}.js"] = 'client/lib/' + c + '.coffee'


# The client app's stylus that will be compiled.
client_stylus = [
	'fonts'
	'peditor.mixins'
	'peditor'
]
client_stylus_list = {}
for s in client_stylus
	client_stylus_list["client/css/#{s}.css"] = 'client/styles/' + s + '.styl'


module.exports = (grunt) ->
	_ = require 'underscore'
	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-stylus')
	grunt.loadNpmTasks('grunt-contrib-watch')

	grunt.initConfig(
		coffee: {
			server: {
				options: {
					bare: true
				}
				files: server_coffee_list
			}
			client: {
				options: {
					bare: true
				}
				files: client_coffee_list
			}
		}

		stylus: {
			client: {
				files: client_stylus_list
			}
		}

		watch: {
			js: {
				files: _.values(client_coffee_list)
				tasks: 'coffee:client'
			}
			css: {
				files: _.values(client_stylus_list)
				tasks: 'stylus:client'
			}
		}
	)

	grunt.registerTask('default', ['coffee', 'stylus'])
