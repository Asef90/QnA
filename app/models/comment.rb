class Comment < ApplicationRecord
  include Authorable

  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true
end
