class Subscription < ApplicationRecord
  belongs_to :customer

  validates :title, presence: true
  validates :price, presence: true
  validates :status, presence: true
  validates :frequency, presence: true
  validates :customer_id, presence: true
  validates :tea_name, presence: true
  validates :tea_description, presence: true
  validates :temperature, numericality: true, presence: true
  validates :brew_time, numericality: true, presence: true

  enum status: {
    active: 0,
    cancelled: 1,
  }

  def self.by_customer(num)
    self.where(customer_id: num.to_i)
  end
end
