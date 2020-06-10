class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :votable_type, uniqueness: { scope: [:votable_id, :user_id] }
  validates :value, presence: true
end
