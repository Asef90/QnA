class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscriptable, polymorphic: true

  validates :subscriptable_type, uniqueness: { scope: [:subscriptable_id, :user_id] }
end
