#!/usr/bin/env zsh

coffee='node_modules/.bin/coffee'
stylus='node_modules/.bin/stylus'

# Compile coffeescripts.
$coffee -o js/kit -cb kit/
$coffee -o js/ -cb app.coffee
$coffee -o js/lib/ -cb lib/
$coffee -o client/js/ -cb client/lib/
$coffee -cb client/widgets/

# Compile stylus.
if [ ! -d client/css/ ]; then
	mkdir client/css/
fi
$stylus -o client/css/ client/styles/ > /dev/null
$stylus client/widgets/*

# Run controller.
node js/kit/server_ctl.js $1