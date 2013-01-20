_ = require 'underscore'
queries = require '../../queries'
data = require '../../data'

build_grid = (tiles, center) ->
  rows = []
  for y in [center.y - 4 .. center.y + 4]
    row = []
    rows.push row
    for x in [center.x - 4 .. center.x + 4]
      tile = _.find tiles, (t) -> t.x is x and t.y is y
      if tile?
        row.push tile
      else
        if center.z is 0
          row.push
            x: x
            y: y
            z: center.z
            terrain: 'wilderness'
        else if center.z is 1
          row.push
            x: x
            y: y
            z: center.z
            terrain: 'nothing'
  rows

visit_tile = (tile, center, character) ->
  retval =
    tile: tile
    terrain: data.terrains[tile.terrain]
  retval

module.exports = (app) ->
  app.get '/map', (req, res, next) ->
    queries.tiles_in_square_around req.character, 5, (err, tiles) ->
      return next(err) if err?
      locals =
        grid: build_grid tiles, req.character
        time: req.time
        data: data
      for row, i in locals.grid
        for tile, j in row
          locals.grid[i][j] = visit_tile tile, locals.center, locals.character
      res.render 'map', locals
