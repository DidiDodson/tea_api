require 'rails_helper'

RSpec.describe 'Subscription API' do
  it 'happy path - finds all of a customers subscriptions' do
    customer1 = create(:customer)
    customer2 = create(:customer)

    tea = double("chamomile")
    allow(tea).to receive(:tea_name).and_return("chamomile")
    allow(tea).to receive(:tea_description).and_return("calming and soothing")
    allow(tea).to receive(:brew_time).and_return(2)
    allow(tea).to receive(:temperature).and_return(100)

    tea2 = double("black")
    allow(tea2).to receive(:tea_name).and_return("black")
    allow(tea2).to receive(:tea_description).and_return("wakes you up")
    allow(tea2).to receive(:brew_time).and_return(3)
    allow(tea2).to receive(:temperature).and_return(95)

    tea3 = double("green")
    allow(tea3).to receive(:tea_name).and_return("green")
    allow(tea3).to receive(:tea_description).and_return("light and fresh")
    allow(tea3).to receive(:brew_time).and_return(2)
    allow(tea3).to receive(:temperature).and_return(105)

    subscription1 = create(:subscription, customer_id: customer1.id, status: "active", tea_name: tea.tea_name, tea_description: tea.tea_description, brew_time: tea.brew_time, temperature: tea.temperature)
    subscription2 = create(:subscription, customer_id: customer1.id, status: "active", tea_name: tea2.tea_name, tea_description: tea2.tea_description, brew_time: tea2.brew_time, temperature: tea2.temperature)
    subscription3 = create(:subscription, customer_id: customer1.id, status: "cancelled", tea_name: tea3.tea_name, tea_description: tea3.tea_description, brew_time: tea3.brew_time, temperature: tea3.temperature)
    subscription4 = create(:subscription, customer_id: customer2.id, status: "cancelled", tea_name: tea.tea_name, tea_description: tea.tea_description, brew_time: tea.brew_time, temperature: tea.temperature)

    get "/api/v1/customers/#{customer1.id}/subscriptions"

    expect(response).to be_successful

    requests = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(requests.count).to eq(3)

    requests.each do |request|
      expect(request).to be_a(Hash)
      expect(request[:type]).to eq("subscriptions")
      expect(request).to have_key(:attributes)
      expect(request[:attributes]).to have_key(:title)
      expect(request[:attributes]).to have_key(:price)
      expect(request[:attributes]).to have_key(:status)
      expect(request[:attributes]).to have_key(:frequency)
      expect(request[:attributes]).to have_key(:customer_id)
      expect(request[:attributes][:customer_id]).to eq(customer1.id)
      expect(request[:attributes][:customer_id]).to_not eq(customer2.id)
      expect(request[:attributes]).to have_key(:tea_name)
      expect(request[:attributes]).to have_key(:tea_description)
      expect(request[:attributes]).to have_key(:brew_time)
      expect(request[:attributes]).to have_key(:temperature)
    end
  end

  it 'sad path - finds all of a customers subscriptions' do
    customer = create(:customer)

    get "/api/v1/customers/#{customer.id}/subscriptions"

    error = (JSON.parse(response.body, symbolize_names: true))[:errors][:details]

    expect(response.status).to eq(404)
    expect(error).to eq("Subscriptions not found")
  end

  it 'happy path - it creates a new subscription' do
    customer = create(:customer)
    tea = double("chamomile")
    allow(tea).to receive(:tea_name).and_return("chamomile")
    allow(tea).to receive(:tea_description).and_return("calming and soothing")
    allow(tea).to receive(:brew_time).and_return(3)
    allow(tea).to receive(:temperature).and_return(100)

    params = {title: 'chamomile',
              status: 'active',
              price: 41.2,
              frequency: 4,
              customer_id: customer.id
            }

    post "/api/v1/customers/#{customer.id}/subscriptions?name=#{tea.tea_name}", headers: {"Content-Type": "application/json"}, params: params.to_json

    expect(response.status).to eq(201)

    request = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(request[:attributes][:title]).to eq("chamomile")
    expect(request[:attributes][:brew_time]).to eq(3)
  end

  it 'sad path - empty validated value - it creates a new subscription' do
    customer = create(:customer)
    tea = double("chamomile")
    allow(tea).to receive(:tea_name).and_return("chamomile")
    allow(tea).to receive(:tea_description).and_return("calming and soothing")
    allow(tea).to receive(:brew_time).and_return(2)
    allow(tea).to receive(:temperature).and_return(100)

    params = {title: '',
              status: 'active',
              price: 41.2,
              frequency: 4,
              customer_id: customer.id
            }

    post "/api/v1/customers/#{customer.id}/subscriptions?name=#{tea.tea_name}", headers: {"Content-Type": "application/json"}, params: params.to_json

    error = (JSON.parse(response.body, symbolize_names: true))[:errors][:details]

    expect(response.status).to eq(400)
    expect(error).to eq("There was an error creating this subscription")
  end

  it 'sad path - incorrect data type - it creates a new subscription' do
    customer = create(:customer)
    tea = double("chamomile")
    allow(tea).to receive(:tea_name).and_return("chamomile")
    allow(tea).to receive(:tea_description).and_return("calming and soothing")
    allow(tea).to receive(:brew_time).and_return(2)
    allow(tea).to receive(:temperature).and_return(100)

    params = {title: '',
              status: 'active',
              price: 'cats',
              frequency: 4,
              customer_id: customer.id
            }

    post "/api/v1/customers/#{customer.id}/subscriptions?name=#{tea.tea_name}", headers: {"Content-Type": "application/json"}, params: params.to_json

    error = (JSON.parse(response.body, symbolize_names: true))[:errors][:details]

    expect(response.status).to eq(400)
    expect(error).to eq("There was an error creating this subscription")
  end

  it 'happy path - updates a subscription' do
    customer = create(:customer)
    tea = double("chamomile")
    allow(tea).to receive(:tea_name).and_return("chamomile")
    allow(tea).to receive(:tea_description).and_return("calming and soothing")
    allow(tea).to receive(:brew_time).and_return(2)
    allow(tea).to receive(:temperature).and_return(100)

    subscription = create(:subscription, customer_id: customer.id, status: "active", tea_name: tea.tea_name, tea_description: tea.tea_description, brew_time: tea.brew_time, temperature: tea.temperature)

    params = {title: 'chamomile',
              status: 'cancelled',
              price: 41.2,
              frequency: 4,
              customer_id: customer.id
            }

    patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}?name=#{tea.tea_name}", headers: {"Content-Type": "application/json"}, params: params.to_json

    expect(response.status).to eq(200)

    request = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(request[:attributes][:status]).to eq("cancelled")
  end

  it 'sad path - empty validated field - updates a subscription' do
    customer = create(:customer)
    tea = double("chamomile")
    allow(tea).to receive(:tea_name).and_return("chamomile")
    allow(tea).to receive(:tea_description).and_return("calming and soothing")
    allow(tea).to receive(:brew_time).and_return(2)
    allow(tea).to receive(:temperature).and_return(100)

    subscription = create(:subscription, customer_id: customer.id, status: "active", tea_name: tea.tea_name, tea_description: tea.tea_description, brew_time: tea.brew_time, temperature: tea.temperature)

    params = {title: 'chamomile',
              status: '',
              price: 41.2,
              frequency: 4,
              customer_id: customer.id
            }

    patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}?name=#{tea.tea_name}", headers: {"Content-Type": "application/json"}, params: params.to_json

    error = (JSON.parse(response.body, symbolize_names: true))[:errors][:details]

    expect(response.status).to eq(400)
    expect(error).to eq("There was an error updating this subscription")
  end

  it 'sad path - incorrect data type - updates a subscription' do
    customer = create(:customer)
    tea = double("chamomile")
    allow(tea).to receive(:tea_name).and_return("chamomile")
    allow(tea).to receive(:tea_description).and_return("calming and soothing")
    allow(tea).to receive(:brew_time).and_return(2)
    allow(tea).to receive(:temperature).and_return(100)

    subscription = create(:subscription, customer_id: customer.id, status: "active", tea_name: tea.tea_name, tea_description: tea.tea_description, brew_time: tea.brew_time, temperature: tea.temperature)

    params = {title: 'chamomile',
              status: '',
              price: 41.2,
              frequency: [34],
              customer_id: customer.id
            }

    patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}?name=#{tea.tea_name}", headers: {"Content-Type": "application/json"}, params: params.to_json

    error = (JSON.parse(response.body, symbolize_names: true))[:errors][:details]

    expect(response.status).to eq(400)
    expect(error).to eq("There was an error updating this subscription")
  end
end
