require 'open-uri'

class Course < ApplicationRecord
  has_many :listings, dependent: :destroy
  has_one_attached :featured_image

  validates_presence_of :url

  scope :published, -> { where(published: true) }

  after_create_commit :import

  def import
    CourseScraper.new(self).call
  end
end
