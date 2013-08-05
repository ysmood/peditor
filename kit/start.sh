node_modules/.bin/coffee -c app.coffee lib

NODE_ENV=production nohup node app.js >> console.log 2>&1 &