class Segy
  def self.open(file)
    instance = allocate
    instance.instance_variable_set(:@file, File.open(file))
    instance
  end

  def close
    @file.close
  end
end
