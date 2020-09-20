#!/usr/bin/env ruby
require 'json'

infile = ARGV[0]
start = ARGV[1].to_i
offset = ARGV[2].to_i

are = JSON.parse(File.read(infile))
for tile in are['Tile_List']['value'] do
  tile['Tile_ID']['value'] += offset if tile['Tile_ID']['value'] >= start
end

File.write(infile, JSON.pretty_generate(are))
