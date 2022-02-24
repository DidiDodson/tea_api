class Tea
  attr_reader :name,
              :description,
              :brew_time,
              :temperature

  def initialize(data)
    @name = data[:name]
    @description = data[:description]
    @brew_time = data[:brew_time]
    @temperature = data[:temperature]
  end
end
