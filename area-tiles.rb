#!/usr/bin/env ruby
require 'json'

are = JSON.parse(File.read(ARGV.first))

puts ARGV.first
puts 'Name(s): ' + are['Name']['value'].to_s
puts 'Tileset: ' + are['Tileset']['value']
puts '(Unique) Tile IDs used'
tiles = are['Tile_List']['value']
for id in tiles.map{|t| t['Tile_ID']['value']}.sort.uniq do
  puts id
end
