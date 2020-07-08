class SubscriptionsController < ApplicationController
  before_action :set_subscriptable, only: %i[create]

  authorize_resource

  def create
    @subscription = current_user.subscriptions.build(subscriptable: @subscriptable)

    if @subscription.save
      render json: { message: 'Successfully subscribed' }, status: :ok
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @subscriptable = model_klass.find(params[:id])
    current_user.subscriptions.find_by(subscriptable: @subscriptable).destroy
    render json: { message: 'Successfully unsubscribed' }, status: :ok
  end

  private

  def param
    "#{params[:subscriptable].singularize}_id".to_sym
  end

  def model_klass
    params[:subscriptable].classify.constantize
  end

  def set_subscriptable
    @subscriptable = model_klass.find(params[param])
  end
end
