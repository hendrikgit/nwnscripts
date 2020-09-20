#!/usr/bin/env ruby

# call with two .set files as arguments

puts ARGV[0] + ", " + ARGV[1]
set1 = File.read(ARGV[0])
set2 = File.read(ARGV[1])

def get_tile_list(set)
  tiles = []
  id = -1
  model = ''
  wm = ''
  for line in set.split do
    m = line.match(/\[TILE(\d+)\]/)
    if m
      if id != -1
        # next [TILE..] block encountered, save info of last one
        tiles << {id: id, model: model, wm: wm}
      end
      id = m[1]
      next
    end
    m = line.match(/Model=(.*)/)
    if m
      model = m[1]
      next
    end
    m = line.match(/WalkMesh=(.*)/)
    if m
      wm = m[1]
      next
    end
  end
  # add last tile also
  tiles << {id: id, model: model, wm: wm}
  return tiles
end

tiles1 = get_tile_list(set1)
tiles2 = get_tile_list(set2).map{|t| [t[:id], t]}.to_h

puts 'Number of tiles in set 1: ' + tiles1.length.to_s
puts 'Number of tiles in set 2: ' + tiles2.keys.length.to_s
puts 'Different tiles:'
replace_model_name = ['ttf02', 'ttf01']
for tile1 in tiles1 do
  tile2 = tiles2[tile1[:id]]
  if !tile2
    puts "Tile ID #{tile1[:id]} does not exist in set2"
  else
    tile2_model = tile2[:model]
    if replace_model_name.length == 2
      tile2_model = tile2_model.sub(replace_model_name[0], replace_model_name[1])
    end
    if tile1[:model] != tile2_model
      puts "Tile #{tile1[:id]} models don't match: #{tile1[:model]} <-> #{tile2_model}"
    end
    if tile1[:wm] != tile2[:wm]
      puts "Tile #{tile1[:id]} walk meshes don't match: #{tile1[:wm]} <-> #{tile2[:wm]}"
    end
  end
end
if tiles2.keys.length > tiles1.length
  puts 'Only in set 2:'
  only2 = tiles2.keys - tiles1.map{|t| t[:id]}
  for id in only2
    puts tiles2[id]
  end
end
