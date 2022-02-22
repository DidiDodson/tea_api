class Api::V1::SubscriptionsController < ApplicationController
  def index
    customer = Customer.find_by(params[:id])
    tea = TeaFacade.find_tea(params[:name])
    if customer.subscriptions == []
      render json: { errors: { details: "Subscriptions not found" } }, status: 404
    else
      render json: SubscriptionsSerializer.new(Subscription.by_customer(customer))
    end
  end

  def create
    tea = TeaFacade.find_tea(params[:name])
    subscription = Subscription.create(subscription_params)
    if subscription.save
      render json: SubscriptionsSerializer.new(Subscription.find(subscription.id)), status: 201
    else
      render json: { errors: { details: "There was an error creating this subscription" } }, status: 400
    end
  end

  def update
    tea = TeaFacade.find_tea(params[:name])
    subscription = Subscription.update(params[:id], subscription_params)

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