class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :rewards

  def author?(resource)
    id == resource.author_id
  end

  def give_reward(reward)
    rewards.push(reward)
  end
end
