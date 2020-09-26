#!/usr/bin/env ruby

folder = ARGV.shift # where the .mdl, .mtr, .plt, .dds, .lod files are
name = ARGV.shift # for example "pmh0_head" (m - male, h - human, 0 phenotype?)
start_idx = ARGV.shift
end_idx = ARGV.shift
offset = ARGV.shift.to_i # can be negative

idxs = (start_idx .. end_idx).to_a.map{|n| n.rjust(3, '0')} # idxs are strings
name_len = name.length

files = Dir.children(folder).sort
files.reverse! if offset > 0 # to not overwrite already existing files

for f in files
  next if !f.start_with?(name)
  nr = f[name_len .. name_len + 2] # nr is a string
  next if !idxs.include?(nr)
  fpath = File.join(folder, f)
  new_nr = (nr.to_i + offset).to_s.rjust(3, '0')
  new_fpath = File.join(folder, name + new_nr + f[name_len + 3 .. -1])
  case f[-3 .. -1]
  when 'mdl', 'mtr'
    File.write(new_fpath, File.read(fpath).gsub(name + nr, name + new_nr))
    File.delete(fpath)
  else
    if File.exists?(new_fpath)
      puts 'File exists: ' + new_fpath
      exit(1)
    end
    File.rename(fpath, new_fpath)
  end
end
