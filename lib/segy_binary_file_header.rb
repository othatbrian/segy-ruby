class SegyBinaryFileHeader

  attr_reader :entries

  def initialize(data)
    @entries = []
    @data = data.dup
    parse(data)
  end

  def bytes(size, start)
    start = start - 3200
    case size
    when 2
      @data.slice(start - 1, size).unpack('s>').shift
    when 4
      @data.slice(start - 1, size).unpack('S>').shift
    else
      @data.slice(start - 1, size)
    end
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
