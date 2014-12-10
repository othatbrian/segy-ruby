require File.dirname(__FILE__) + '/lib/segy'

segy = Segy.open('../test_file')

puts "=" * 31 + "  EBCDIC HEADER  " + "=" * 32

puts segy.textual_file_header

puts "=" * 29 + "  BINARY FILE HEADER  " + "=" * 29

location = 3200
segy.binary_file_header.entries.each do |array|
  bytes, value = array
  puts sprintf('bytes %4d - %4d: ', location + 1, location + bytes) + value.to_s
  location += bytes
end

puts "=" * 32 + "  TRACE HEADER  " + "=" * 32

traces = 0
begin
  while trace = segy.next_trace do
    traces += 1
  end
rescue IncompleteTraceHeader
  STDERR.puts "Stopped at incomplete trace!"
  STDERR.puts "Processed #{traces} traces"
  exit 1
end

segy.close
