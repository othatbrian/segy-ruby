require File.dirname(__FILE__) + '/ebcdic'
require File.dirname(__FILE__) + '/binary_file_header'

class Segy

  attr_reader :textual_file_header
  attr_reader :binary_file_header

  def self.open(file)
    instance = allocate
    instance.send :setup, file
    instance
  end

  def close
    @file.close
  end

  private

  def setup(file)
    @file = File.open(file)
    @textual_file_header = @file.read(3200).unpack('C*').collect { |int| Ebcdic.to_ascii int }.join
    @binary_file_header = BinaryFileHeader.new(@file.read(400))
  end

end
