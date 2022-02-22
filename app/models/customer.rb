class Customer < ApplicationRecord
  has_many :subscriptions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true, presence: true
  validates :address, presence: true
end
