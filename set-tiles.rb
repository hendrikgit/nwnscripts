#!/usr/bin/env ruby
require 'csv'
require 'json'

puts ARGV.first
tileset = File.read(ARGV.first)
palstd = File.basename(ARGV.first).sub(/\.set$/, 'palstd.itp.json')

def flatten_list(list)
  # returns a flat array of [resref, strref] pairs
  result = []
  for el in list do
    if el['LIST']
      result.concat(flatten_list(el['LIST']['value']))
    else
      result << [el['RESREF']['value'], el['STRREF']['value']]
    end
  end
  return result
end

if File.exists?(palstd)
  strrefs = flatten_list(JSON.parse(File.read(palstd))['MAIN']['value']).to_h
end

if File.exists?('dialog.csv')
  tlk = CSV.read('dialog.csv').map{|row| [row.first.to_i, row.last]}.to_h
end

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
  output = [tile[:id].to_s, tile[:model], tile[:image]]
  if strrefs
    strref = strrefs[tile[:model]]
    if strref
      output << strref
      output << tlk[strref] if tlk && tlk[strref]
    end
  end
  puts output.join(', ')
end
