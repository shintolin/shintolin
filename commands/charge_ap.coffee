db = require '../db'
queries = require '../queries'

module.exports = (character, ap, cb) ->
  if ap < 0
    cb 'Invalid AP Quantity'
  else if ap > character.ap
    cb 'Insufficient AP'
  else
    query =
      _id: character._id
    update =
      $inc:
        ap: 0 - ap
      $set:
        last_action: new Date()
    db.characters().updateOne query, update, cb
