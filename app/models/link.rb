class Link < ApplicationRecord
  URL_FORMAT = /https?:\/\/[\S]+/

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URL_FORMAT }
end
