require 'rails_helper'

RSpec.describe Tea do
  let(:data) do
    {
      "id": 1,
      "name": "green",
      "description": "Rich in antioxidants and reduces inflammation.",
      "brew_time": 2,
      "temperature": 80
      }
  end
  let(:tea) { Tea.new(data) }

  it 'exists with attributes' do
    expect(tea.name).to eq("green")
    expect(tea.description).to eq("Rich in antioxidants and reduces inflammation.")
    expect(tea.brew_time).to eq(2)
    expect(tea.temperature).to eq(80)
  end
end
