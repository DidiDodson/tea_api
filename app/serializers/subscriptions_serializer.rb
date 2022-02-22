class SubscriptionsSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :status, :frequency, :customer_id, :tea_name, :tea_description, :brew_time, :temperature
end
