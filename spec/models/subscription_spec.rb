require 'rails_helper'

describe Subscription, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:frequency) }
    it { should validate_numericality_of(:frequency) }
    it { should validate_presence_of(:customer_id) }
    it { should validate_presence_of(:tea_name) }
    it { should validate_presence_of(:tea_description) }
    it { should validate_presence_of(:temperature) }
    it { should validate_numericality_of(:temperature) }
    it { should validate_presence_of(:brew_time) }
    it { should validate_numericality_of(:brew_time) }
  end
end
