class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :rewards
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscripted_questions, through: :subscriptions, source: :subscriptable, source_type: 'Question'

  def self.from_omniauth(auth)
    FindForOauthService.new(auth).call
  end

  def self.find_or_create(email)
    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user
  end

  def author?(resource)
    id == resource.author_id
  end

  def give_reward(reward)
    rewards.push(reward)
  end
end
