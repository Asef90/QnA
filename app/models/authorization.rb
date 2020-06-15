class Authorization < ApplicationRecord
  belongs_to :user, optional: true

  validates :provider, presence: true, uniqueness: { scope: :uid }
  validates :uid, presence: true
end
