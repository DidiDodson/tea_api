class TeaFacade
  class << self
    def find_tea(name)
      result = TeaService.get_one_tea(name)
    end
  end
end
