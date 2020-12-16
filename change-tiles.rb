#!/usr/bin/env ruby

list = File.read(ARGV[0]).split("\n").map do |row|
  id, mdl, img = row.split(',')
  [id.to_i, [mdl, img]]
end.to_h

max_id = list.keys.map{|k| k.to_i}.max

tileset = File.read(ARGV[1])

id = -1
model = ''
image = ''
output = []
for line in tileset.lines do
  if id <= max_id
    m = line.match(/\[TILE(\d+)\]/)
    if m
      id = m[1].to_i
      output << line
      next
    end
    if line.start_with?('Model=')
      output << "Model=#{list[id][0]}\r\n"
      next
    end
    if line.start_with?('ImageMap2D=')
      output << "ImageMap2D=#{list[id][1]}\r\n"
      next
    end
  end
  output << line
end

File.write('output.set', output.join)
