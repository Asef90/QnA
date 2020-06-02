class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope { order(best_mark: :desc) }

  def set_best_mark
    unless best?
      transaction do
        Answer.where(question_id: question_id).update_all(best_mark: false)
        update!(best_mark: true)
        author.give_reward(question.reward) if question.with_reward?
      end
    end
  end

  def best?
    best_mark
  end

end
