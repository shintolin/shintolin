module.exports = (app) ->
  app.get '/', (req, res) ->
    res.render 'home', message: req.param('msg')
