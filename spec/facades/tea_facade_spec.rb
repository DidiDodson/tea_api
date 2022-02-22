require 'rails_helper'

RSpec.describe TeaFacade do
  it 'finds one tea by name' do
    name = 'black'

    result = TeaService.get_one_tea(name)

    expect(result[:name]).to eq('black')
    expect(result[:description]).to eq('Boosts heart health and lowers cholesterol.')
    expect(result[:brew_time]).to eq(3)
    expect(result[:temperature]).to eq(85)
  end
end
