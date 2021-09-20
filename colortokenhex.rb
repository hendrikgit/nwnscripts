Dir['unpacked/nss/*.nss'].each do |fn|
  content = File.read(fn, encoding: 'cp1252')
  content_hex = content.gsub(/<c...>/) do |m|
    '<c' + m[2 .. 4].split('').map{|c| '\\x' + c.ord.to_s(16).upcase.rjust(2, '0')}.join + '>'
  end
  File.write(fn, content_hex)
end
