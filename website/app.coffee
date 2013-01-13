express = require 'express'
MongoSession = require('connect-mongo')(express)
config = require '../config'
game = require '../game/app'
routes = require('require-directory')(module, "#{__dirname}/routes")

debug = process.env.NODE_ENV isnt 'production'

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.use '/game', game
app.use express.favicon("#{__dirname}/public/favicon.ico")
app.use express.static "#{__dirname}/public"

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session
  secret: config.session_secret
  store: new MongoSession(url: config.mongo_uri)

app.use app.router
app.use express.errorHandler
  dumpExceptions: debug
  showStack: debug

route app for key, route of routes

unless module.parent?
  app.listen config.port, ->
    console.log "SHINTOLIN (WEBSITE) listening on port #{config.port}"
