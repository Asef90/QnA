module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_votable, only: %i[vote_up vote_down]
  end

  def vote_up
    handle_vote(votable: @votable, value: 1)
  end

  def vote_down
    handle_vote(votable: @votable, value: -1)
  end

  private

  def handle_vote(votable:, value:)
    if !current_user.author?(votable)
      votable.process_vote(user: current_user, value: value)
      render json: { id: votable.id, type: votable.class.name, number: votable.votes_number }
    else
      render json: 'No roots', status: :forbidden
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

end
