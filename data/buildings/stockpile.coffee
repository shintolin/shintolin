module.exports =
  name: 'Stockpile'
  size: 'tiny'
  hp: 25
  actions: ['take_building', 'give_building', 'write']
  tags: ['visible_inventory', 'inventory_doesnt_decay', 'guard_take']

  build: (character, tile) ->
    takes:
      ap: 10
      skill: 'trailblazing'
      items:
        stone: 8
    gives:
      xp:
        wanderer: 10

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 5
      skill: 'trailblazing'
      items:
        stone: 1
    gives:
      tile_hp: 10
      xp:
        wanderer: 1

  text:
    built: 'You stake out a stockpile on the ground.'
