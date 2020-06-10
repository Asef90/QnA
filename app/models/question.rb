class Question < ApplicationRecord
  include Attachable
  include Authorable
  include Linkable
  include Votable

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def with_reward?
    reward.present?
  end
end
