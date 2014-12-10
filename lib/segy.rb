require File.dirname(__FILE__) + '/ebcdic'

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

end
