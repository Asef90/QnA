module Subscripted
  extend ActiveSupport::Concern
  included do
    before_action :set_subscriptable, only: %i[subscribe unsubscribe]
  end

  def subscribe
    authorize! :subscribe, @subscriptable
    @subscription = current_user.subscriptions.build(subscriptable: @subscriptable)

    if @subscription.save
      render json: { message: 'Successfully subscribed' }, status: :ok
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unsubscribe
    authorize! :unsubscribe, @subscriptable
    @subscription = Subscription.find_by(subscriptable: @subscriptable, user: current_user)
    @subscription.destroy
    render json: { message: 'Successfully unsubscribed' }, status: :ok
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_subscriptable
    @subscriptable = model_klass.find(params[:id])
  end
end
