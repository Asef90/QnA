# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    user ? user_abilities : guest_abilities
  end

  def guest_abilities
    can :read, [Question, Answer]
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer]
    can :create_comment, [Question, Answer]
    can [:update, :destroy], [Question, Answer], { author_id: user.id }
    can :set_best, Answer, question: { author_id: user.id }
    can :index, Reward, { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :destroy, Link, linkable: { author_id: user.id }

    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      !user.author?(votable)
    end
  end
end
