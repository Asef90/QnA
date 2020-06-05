class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rewards = current_user.rewards.with_attached_image
  end
end
