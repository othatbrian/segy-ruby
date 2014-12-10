file = File.open '../test_file'

EBCDIC_2_ASCII = ["000102039C09867F978D8E0B0C0D0E0F101112139D8508871819928F1C1D1E1F"+
  "80818283840A171B88898A8B8C050607909116939495960498999A9B14159E1A"+
  "20A0A1A2A3A4A5A6A7A8D52E3C282B7C26A9AAABACADAEAFB0B121242A293B5E"+
  "2D2FB2B3B4B5B6B7B8B9E52C255F3E3FBABBBCBDBEBFC0C1C2603A2340273D22"+
  "C3616263646566676869C4C5C6C7C8C9CA6A6B6C6D6E6F707172CBCCCDCECFD0"+
  "D17E737475767778797AD2D3D45BD6D7D8D9DADBDCDDDEDFE0E1E2E3E45DE6E7"+
  "7B414243444546474849E8E9EAEBECED7D4A4B4C4D4E4F505152EEEFF0F1F2F3"+
  "5C9F535455565758595AF4F5F6F7F8F930313233343536373839FAFBFCFDFEFF"].pack("H*")

puts "=" * 31 + "  EBCDIC HEADER  " + "=" * 32

file.read(3200).unpack('C*').map { |int| putc EBCDIC_2_ASCII[int] }

puts "=" * 29 + "  BINARY FILE HEADER  " + "=" * 29

header = file.read(400).unpack('s>*')
header.each_with_index do |value, index|
  byte = index * 2 + 1
  puts 'bytes ' + sprintf('%03d - %03d', byte, byte + 1) + ": " + value.to_s
end

puts "=" * 29 + "  TRACE FILE HEADER  " + "=" * 30

bytes_read = 0

7.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 4) + file.read(4).unpack('l>').first.to_s
  bytes_read += 4
end
4.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 2) + file.read(2).unpack('s>').first.to_s
  bytes_read += 2
end
8.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 4) + file.read(4).unpack('l>').first.to_s
  bytes_read += 4
end
2.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 2) + file.read(2).unpack('s>').first.to_s
  bytes_read += 2
end
4.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 4) + file.read(4).unpack('l>').first.to_s
  bytes_read += 4
end
46.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 2) + file.read(2).unpack('s>').first.to_s
  bytes_read += 2
end
5.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 4) + file.read(4).unpack('l>').first.to_s
  bytes_read += 4
end
2.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 2) + file.read(2).unpack('s>').first.to_s
  bytes_read += 2
end
1.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 4) + file.read(4).unpack('l>').first.to_s
  bytes_read += 4
end
8.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 2) + file.read(2).unpack('s>').first.to_s
  bytes_read += 2
end
1.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 4) + file.read(4).unpack('l>').first.to_s
  bytes_read += 4
end
6.times do
  puts sprintf('bytes %03d - %03d: ', bytes_read + 1, bytes_read + 2) + file.read(2).unpack('s>').first.to_s
  bytes_read += 2
end

file.close
