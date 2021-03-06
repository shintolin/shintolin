_ = require 'underscore'
MAX_OCCUPANCY = 8

module.exports =
  name: 'Hospital'
  size: 'large'
  hp: 100
  interior: '_interior_hospital'
  upgrade: true
  actions: ['write']
  max_occupancy: MAX_OCCUPANCY

  recovery: (character, tile) ->
    return 0 unless tile.z isnt 0
    return 0 unless tile.people?.length <= MAX_OCCUPANCY
    return 0 unless tile.settlement_id?.toString() is character.settlement_id?.toString()
    if character.hp <= 0
      1
    else if _.contains(character.skills, 'medicine')
      1
    else
      .5

  build: (character, tile) ->
    takes:
      ap: 25
      settlement: true
      building: 'longhouse'
      skill: 'hospitaller'
      items:
        thyme: 7
        bark: 7
        poultice: 7
    gives:
      xp:
        crafter: 25

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 10
      skill: 'hospitaller'
      items:
        thyme: 2
        bark: 2
        poultice: 2
    gives:
      tile_hp: 25
      xp:
        crafter: 5

  text:
    built: 'You organise your medicinal supplies and establish a hospital in this building.'
