require 'rails_helper'

RSpec.describe TeaService do
  describe 'class methods' do
    it 'accesses one tea' do
      result = TeaService.get_one_tea('black')

      expect(result).to have_key(:name)
      expect(result).to have_key(:description)
      expect(result).to have_key(:brew_time)
      expect(result).to have_key(:temperature)
    end
  end
end
