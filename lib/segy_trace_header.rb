class SegyTraceHeader

  attr_reader :entries

  def initialize(data)
    @entries = []
    @data = data.dup
    parse(data)
  end

  def bytes(size, start)
    case size
    when 2
      @data.slice(start - 1, size).unpack('s>').shift
    when 4
      @data.slice(start - 1, size).unpack('S>').shift
    else
      @data.slice(start - 1, size)
    end
  end

  def samples_in_trace
    bytes(2, 115)
  end

  private

  def parse(data)
    [4,4,4,4,4,4,4,2,2,2,2,4,4,4,4,4,4,4,4,2,2,4,4,4,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,4,4,4,4,4,2,2,4,2,2,2,2,2,6,4,2,2,8].each do |bytes|
      case bytes
      when 2
        @entries.push [bytes, data.slice!(0, bytes).unpack('s>').shift]
      when 4
        @entries.push [bytes, data.slice!(0, bytes).unpack('S>').shift]
      else
        data.slice!(0, bytes)
        @entries.push [bytes, nil]
      end
    end
  end

end
