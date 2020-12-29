require 'fileutils'

models = File.read('models.txt').split("\n")

models.each do |mdl|
  if mdl.length + 2 > 16
    puts "#{mdl}: name too long with added _w"
  end
end

set = File.read('hak/sfwinterrural/sfwinterrural.set')
models.each do |mdl|
  set.sub!("Model=#{mdl}", "Model=#{mdl}_w")
  set.sub!("WalkMesh=#{mdl}", "WalkMesh=#{mdl}_w")
end
File.write('hak/sfwinterrural/sfwinterrural.set', set)

models.each do |mdl|
  FileUtils.cp "hak/sfarkontileset1/#{mdl}.mdl", "hak/sfwinterrural/#{mdl}_w.mdl"
  FileUtils.cp "hak/sfarkontileset1/#{mdl}.wok", "hak/sfwinterrural/#{mdl}_w.wok"

  #FileUtils.cp "hak/sfarkontileset1/#{mdl}.mdl", "/home/hal/nwntools/cm/input/#{mdl}.mdl"

  #FileUtils.cp "/home/hal/nwntools/cm/output/#{mdl}.mdl", "hak/sfwinterrural/#{mdl}_w.mdl"
  #FileUtils.cp "/home/hal/nwntools/cm/output/#{mdl}.wok", "hak/sfwinterrural/#{mdl}_w.wok"
end

models.each do |mdl|
  f = File.read("hak/sfwinterrural/#{mdl}_w.mdl")
  f.gsub!(mdl, "#{mdl}_w")
  f.gsub!(/bitmap ttr01_grass02/i, 'bitmap tts02_grass02')
  f.gsub!(/bitmap ttr01_road01/i, 'bitmap tts02_road01')
  File.write("hak/sfwinterrural/#{mdl}_w.mdl", f)
end

models.each do |mdl|
  lines = File.read("hak/sfwinterrural/#{mdl}_w.mdl").split(/\r?\n/)
  aabb_idx = lines.find_index{|l| l.strip.start_with?('node aabb')}
  p mdl if aabb_idx.nil? # binary mdl
  faces_idx = -1
  aabb_end_idx = -1
  lines.each_with_index do |l, idx|
    if idx > aabb_idx && l.strip.start_with?('faces')
      faces_idx = idx + 1
    end
    if idx > faces_idx && l.strip.start_with?('aabb')
      aabb_end_idx = idx
      break
    end
  end
  for idx in faces_idx ... aabb_end_idx do
    lines[idx].sub!(/ 3$/, ' 19')
  end
  File.write("hak/sfwinterrural/#{mdl}_w.mdl", lines.join("\r\n"))
end
