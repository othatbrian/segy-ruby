require File.dirname(__FILE__) + '/ebcdic'
require File.dirname(__FILE__) + '/binary_file_header'

class Segy

  def self.open(file)
    instance = allocate
    instance.instance_variable_set(:@file, File.open(file))
    instance
  end

  def close
    @file.close
  end

  def file_header
    @file.read(3200).unpack('C*').collect { |int| Ebcdic.to_ascii int }.join
  end

  def binary_file_header
    BinaryFileHeader.new(@file.read(400))
  end

end
