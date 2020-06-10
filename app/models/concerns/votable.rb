module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def votes_number
    votes.sum(:value)
  end

  def process_vote(user:, value:)
    vote = votes.find_by(user_id: user.id)
    votes.destroy(vote) if vote && (-vote.value == value)
    votes.create(user_id: user.id, value: value) unless vote
  end
end
