require File.dirname(__FILE__) + '/lib/segy'

#segy = Segy.open('/scra/7day/bds.sgy')
segy = Segy.open('/seis/218/bill_writes/segy/EIMerge_1-6_BDS.sgy')

puts "=" * 31 + "  EBCDIC HEADER  " + "=" * 32

#puts segy.textual_file_header

puts "=" * 29 + "  BINARY FILE HEADER  " + "=" * 29

location = 3200
segy.binary_file_header.entries.each do |array|
#  bytes, value = array
#  puts sprintf('bytes %4d - %4d: ', location + 1, location + bytes) + value.to_s
#  location += bytes
end

# puts "=" * 32 + "  TRACE HEADER  " + "=" * 32

traces = 0
dead_traces = 0
bad_traces = 0
begin
  while trace = segy.next_trace do
    traces += 1
    if trace.header.bytes(2, 29) == 2
      dead_traces += 1
      puts "Dead trace before #{segy.file.pos}"
    end
    if trace.header.bytes(2, 171) == 0
      bad_traces += 1
      puts "Bad trace before #{segy.file.pos}"
    end
  end
rescue IncompleteTraceHeader
end

STDERR.puts "Processed #{traces} traces"
STDERR.puts "Found #{dead_traces} dead traces"
STDERR.puts "Found #{bad_traces} traces with bytes 171-172 == 0"
STDERR.puts "Position: #{segy.file.pos}"

segy.close
