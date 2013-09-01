(function(){

  var constructTerrainLookup = function(terrains){
    var retval = {};
    $.each(terrains, function(){
      retval[this.id] = this;
    });
    return retval;
  };

  var generateKey = function(tile){
    return tile.x + 'x' + tile.y;
  };

  var findBoundaries = function(tiles){
    var xs = _.pluck(tiles, 'x');
    var ys = _.pluck(tiles, 'y');
    return {
      left: _.min(xs),
      right: _.max(xs),
      top: _.min(ys),
      bottom: _.max(ys)
    };
  };

  var constructTileLookup = function(tiles){
    var retval = {};
    $.each(tiles, function(){
      retval[generateKey(this)] = this;
    });
    return retval;
  };

  var constructMapTable = function(terrains, cb){
    return function(tiles){
      var bounds = findBoundaries(tiles);
      var terrainLookup = constructTerrainLookup(terrains);
      var tileLookup = constructTileLookup(tiles);
      var $map = $('#map');
      var $table = $('<table></table>');
      for(var y = bounds.top; y <= bounds.bottom; y++){
        var $tr = $('<tr></tr>');
        for(var x = bounds.left; x <= bounds.right; x++){
          var key = generateKey({x: x, y: y});
          var tile = tileLookup[key];
          if(!tile){
            tile = {x: x, y: y, terrain: 'wilderness'};
          }
          var $td = $('<td></td>');
          $td.addClass('tile-' + terrainLookup[tile.terrain].style);
          if(tile.settlement_id && tile.settlement_id.length){
            $td.addClass('settlement-' + tile.settlement_id);
          }
          if(tile.region && tile.region.length){
            $td.addClass('region-' + tile.region);
          }
          $td.attr('id', key);
          $td.data('x', tile.x);
          $td.data('y', tile.y);
          $td.data('z', tile.z);
          $td.data('terrain', tile.terrain);
          $tr.append($td);
        }
        $table.append($tr);
      }
      $map.append($table);
      cb();
    };
  };

  var constructSettlements = function(settlements){
    var $settlements = $('#settlements');
    var $ul = $('<ul></ul>');
    $.each(settlements, function(){
      var settlement = this;

      var $li = $('<li></li>');
      $li.attr('id', settlement._id);
      $li.text(settlement.name);
      $li.mouseover(function(){
        $('.settlement-' + settlement._id).addClass('highlight');
      });
      $li.mouseout(function(){
        $('#map td').removeClass('highlight');
      });
      $ul.append($li);
    });
    $settlements.append($ul);
  };

  var constructRegions = function(regions){
    var $regions = $('#regions');
    var $ul = $('<ul></ul>');
    $.each(regions, function(){
      var region = this;

      var $li = $('<li></li>');
      $li.attr('id', region.id);
      $li.text(region.name);
      $li.mouseover(function(){
        $('.region-' + region.id).addClass('highlight');
      });
      $li.mouseout(function(){
        $('#map td').removeClass('highlight');
      });
      $ul.append($li);
    });
    $regions.append($ul);
  };

  $(function(){
    $.ajax({
      url: '/manage/api/map/metadata',
      success: function(metadata){
        $.ajax({
          url: '/manage/api/map',
          success: constructMapTable(metadata.terrains, function(){
            constructSettlements(metadata.settlements || []);
            constructRegions(metadata.regions || []);
          })
        });
      }
    });
  });

})();
