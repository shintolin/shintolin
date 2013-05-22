module.exports =
  id: 'timber'
  name: 'plank of timber'

  craft: (character, tile) ->
    takes:
      ap: 12
      tools: ['stone_carpentry']
      skill: 'carpentry'
      items:
        log: 1
    gives:
      items:
        timber: 1
      xp:
        crafter: 5