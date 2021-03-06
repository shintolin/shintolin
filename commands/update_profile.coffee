async = require 'async'
db = require '../db'
hash_password = require './hash_password'
get_character_by_email = require '../queries/get_character_by_email'

module.exports = (character, bio, image_url, title_id, email, password, cb) ->
  return cb('Invalid Title') if title_id?.length and not character.badges[title_id]
  async.series [
    (cb) ->
      return cb() unless email?.length and email isnt character.email
      get_character_by_email email, (err, existing_character) ->
        return cb(err) if err?
        return cb() unless existing_character?
        return cb('EMAIL_TAKEN') if existing_character._id isnt character._id
        cb()
    (cb) ->
      query =
        _id: character._id
      update =
        $set:
          bio: bio ? ''
          image_url: image_url ? ''

      if title_id?.length
        update.$set.title = title_id
      else
        update.$unset =
          title: true

      if email?.length
        update.$set.email = email

      if password?.length
        update.$set.password = hash_password password

      db.characters().updateOne query, update, cb
  ], cb
