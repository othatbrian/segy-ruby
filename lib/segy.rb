require File.dirname(__FILE__) + '/ebcdic'
require File.dirname(__FILE__) + '/segy_binary_file_header'
require File.dirname(__FILE__) + '/segy_trace'
require File.dirname(__FILE__) + '/segy_trace_header'

class Segy

  attr_reader :textual_file_header
  attr_reader :binary_file_header

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
    data = @file.read(header.samples_per_trace * sample_size)
    trace = SegyTrace.new(header, data)
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

  private

  def setup(file)
    @file = File.open(file)
    @textual_file_header = @file.read(3200).unpack('C*').collect { |int| Ebcdic.to_ascii int }.join
    @binary_file_header = SegyBinaryFileHeader.new(@file.read(400))
  end

end
