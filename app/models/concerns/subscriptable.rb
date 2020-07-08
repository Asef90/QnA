module Subscriptable
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions, as: :subscriptable, dependent: :destroy
    has_many :subscribers, through: :subscriptions, source: :user
  end

  def has_subscription_from?(user)
    subscribers.find_by(id: user.id).present?
  end
end
