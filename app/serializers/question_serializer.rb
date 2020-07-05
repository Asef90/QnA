class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :author_id, :created_at, :updated_at, :files
  has_many :links
  has_many :comments

  def files
    files_data = []
    object.files.each {|file| files_data.push(name: file.filename.to_s,
                                              url: Rails.application.routes.url_helpers.rails_blob_url(file))}
    files_data
  end
end
