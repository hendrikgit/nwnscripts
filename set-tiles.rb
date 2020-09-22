#!/usr/bin/env ruby
puts ARGV.first
tileset = File.read(ARGV.first)
tiles = []
id = -1
model = ''
image = ''
for line in tileset.lines do
  m = line.match(/\[TILE(\d+)\]/)
  if m
    tiles << {id: id, model: model, image: image} if id != -1
    id = m[1]
    next
  end
  m = line.match(/Model=(\w*)/)
  if m
    model = m[1]
    next
  end
  m = line.match(/ImageMap2D=(\w*)/)
  if m
    image = m[1]
    next
  end
end
tiles << {id: id, model: model, image: image}

puts 'Number of tiles: ' + tiles.count.to_s
for tile in tiles do
  puts "#{tile[:id]}: #{tile[:model]}, #{tile[:image]}"
end
