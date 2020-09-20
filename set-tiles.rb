#!/usr/bin/env ruby
puts ARGV.first
tileset = File.read(ARGV.first)
tiles = []
for line in tileset.split do
  m = line.match(/\[TILE(\d+)\]/)
  if m
    tiles << m[1].to_i
  end
end

puts 'Number of tiles: ' + tiles.count.to_s
p tiles
