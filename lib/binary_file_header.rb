class BinaryFileHeader

  attr_reader :entries

  def initialize(data)
    @entries = []
    parse(data)
  end

  private

  def parse(data)
    [4,4,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,240,2,2,2,94].each do |bytes|
      case bytes
      when 2
        entries.push [bytes, data.slice!(0, bytes).unpack('s>').shift]
      when 4
        entries.push [bytes, data.slice!(0, bytes).unpack('S>').shift]
      else
        data.slice!(0, bytes)
        entries.push [bytes, nil]
      end
    end
  end

end
