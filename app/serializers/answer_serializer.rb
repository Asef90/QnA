class AnswerSerializer < ActiveModel::Serializer

  attributes :id, :author_id, :body, :created_at, :updated_at, :files
  has_many :links
  has_many :comments

  def files
    files_data = []
    object.files.each {|file| files_data.push(name: file.filename.to_s,
                                              url: Rails.application.routes.url_helpers.rails_blob_url(file))}
    files_data
  end
end
