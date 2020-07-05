class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :body, :created_at, :updated_at
end
