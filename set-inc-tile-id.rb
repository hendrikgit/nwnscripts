#!/usr/bin/env ruby

infile = ARGV[0]
offset = ARGV[1].to_i

for line in File.read(infile).lines do
  m = line.match(/\[TILE(\d+)\]/)
  if m
    new_id = m[1].to_i + offset
    line = "[TILE#{new_id}]"
  end
  puts line
end
