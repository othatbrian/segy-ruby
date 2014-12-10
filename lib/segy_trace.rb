class SegyTrace

  attr_reader :header
  attr_reader :data

  def initialize(header, data)
    @header = header
    @data = data
  end

end
