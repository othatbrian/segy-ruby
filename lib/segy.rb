require File.dirname(__FILE__) + '/ebcdic'
require File.dirname(__FILE__) + '/segy_binary_file_header'
require File.dirname(__FILE__) + '/segy_trace'
require File.dirname(__FILE__) + '/segy_trace_header'

class Segy

  attr_reader :textual_file_header
  attr_reader :binary_file_header
  attr_reader :file

  def self.open(file)
    instance = allocate
    instance.send(:setup, file)
    instance
  end

  def close
    @file.close
  end

  def first_trace
    @file.seek(3600, :SET)
    header = SegyTraceHeader.new(@file.read(240))
    data = @file.read(header.samples_per_trace * sample_size)
    trace = SegyTrace.new(header, data)
  end

  def next_trace
    header = SegyTraceHeader.new(@file.read(240))
#    begin
      data = @file.read(trace_data_size)
#    rescue
#      location = 0
#      header.entries.each do |entry|
#        bytes, value = entry
#        puts sprintf("bytes %03d - %03d: ", location + 1, location + bytes) + value.to_s
#        location += bytes
#      end
#      raise
#    end
    trace = SegyTrace.new(header, data)
  end

  def samples_per_trace
    @samples_per_trace ||= @binary_file_header.bytes(2, 3221)
  end

  def sample_size
    @sample_size ||= begin
      case @binary_file_header.bytes(2, 3225)
      when 1,2,4,5
        4
      when 3
        2
      when 8
        1
      end
    end
  end

  def trace_data_size
    @trace_data_size ||= samples_per_trace * sample_size
  end

  private

  def setup(file)
    @file = File.open(file)
    @textual_file_header = @file.read(3200).unpack('C*').collect { |int| Ebcdic.to_ascii int }.join
    @binary_file_header = SegyBinaryFileHeader.new(@file.read(400))
  end

end
