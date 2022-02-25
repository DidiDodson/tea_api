class Api::V1::SubscriptionsController < ApplicationController
  def index
    customer = Customer.find(params[:customer_id])

    render json: SubscriptionsSerializer.new(Subscription.by_customer(customer.id))
  end

  def create
    tea = TeaFacade.find_tea(params[:name])
    subscription = Subscription.create(subscription_params)

    subscription.tea_name = tea.name
    subscription.tea_description = tea.description
    subscription.brew_time = tea.brew_time
    subscription.temperature = tea.temperature

    if subscription.save
      render json: SubscriptionsSerializer.new(Subscription.find(subscription.id)), status: 201
    else
      render json: { errors: { details: "There was an error creating this subscription" } }, status: 400
    end
  end

  def update
    tea = TeaFacade.find_tea(params[:name])
    subscription = Subscription.update(params[:id], subscription_params)
    subscription.tea_name = tea.name
    subscription.tea_description = tea.description
    subscription.brew_time = tea.brew_time
    subscription.temperature = tea.temperature

    if subscription.save
      render json: SubscriptionsSerializer.new(subscription)
    else
      render json: { errors: { details: "There was an error updating this subscription" } }, status: 400
    end
  end

  private

  def subscription_params
    params.permit(:title, :customer_id, :status, :price, :frequency, :tea_name, :tea_description, :brew_time, :origin, :temperature)
  end
end
