require 'fileutils'

models = File.read('models.txt').split("\n")

set = File.read('hak/sfwintertileset/sfwinter.set')
models.each do |mdl|
 set.sub!("Model=#{mdl}", "Model=#{mdl}_w")
end
File.write('hak/sfwintertileset/sfwinter.set', set)

models.each do |mdl|
 FileUtils.cp "hak/sfarkontileset1/#{mdl}.mdl", "hak/sfwintertileset/#{mdl}_w.mdl"
 FileUtils.cp "hak/sfarkontileset1/#{mdl}.wok", "hak/sfwintertileset/#{mdl}_w.wok"
end

models.each do |mdl|
  f = File.read("hak/sfwintertileset/#{mdl}_w.mdl")
  f.gsub!(mdl, "#{mdl}_w")
  f.gsub!(/bitmap ttr01_grass02/i, 'bitmap tts02_grass02')
  File.write("hak/sfwintertileset/#{mdl}_w.mdl", f)
end

models.each do |mdl|
  lines = File.read("hak/sfwintertileset/#{mdl}_w.mdl").split("\r\n")
  aabb_idx = lines.find_index{|l| l.strip.start_with?('node aabb')}
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
  File.write("hak/sfwintertileset/#{mdl}_w.mdl", lines.join("\r\n"))
end
