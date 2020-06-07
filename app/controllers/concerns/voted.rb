module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_votable, only: %i[vote]
  end

  def vote
    if !current_user.author?(@votable)
      vote = @votable.votes.find_by(user_id: current_user.id)

      @votable.votes.destroy(vote) if vote && ((-vote.value).to_s == params[:value])

      @votable.votes.create(user_id: current_user.id, value: params[:value]) unless vote

      render json: { id: @votable.id, type: @votable.class.name, number: @votable.votes_number }
    else
      render json: 'No roots', status: :forbidden
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

end
