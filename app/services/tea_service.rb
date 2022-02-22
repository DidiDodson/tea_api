class TeaService
  class << self
    def conn
      Faraday.new(url: "https://tea-api-vic-lo.herokuapp.com/")
    end

    def get_one_tea(name)
      result = conn.get("tea/#{name}")

      JSON.parse(result.body, symbolize_names: true)
    end
  end
end
