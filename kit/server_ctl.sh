# Compile coffeescripts.
node_modules/.bin/coffee -cb kit lib client/lib app.coffee

# Compile stylus.
node_modules/.bin/stylus client/styles > /dev/null

# Run controller.
node kit/server_ctl.js $1