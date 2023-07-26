require 'open-uri'

class Course < ApplicationRecord
  has_many :listings, dependent: :destroy
  has_one_attached :featured_image

  validates_presence_of :url
  validates_uniqueness_of :url

  scope :published, -> { where(published: true) }
  scope :purchaseable, -> { published } # used on /courses

  before_validation do
    sanitize_url
  end

  after_create_commit :import

  def sanitize_url
    self.url = self.url.split('?')[0].split('#')[0].chomp('/')
  end

  def import
    CourseScraper.new(self).call
  end

  def lowest_price
    listings.purchaseable.lowest_priced.first.price rescue nil
  end

  def next_lowest_price
    listings.purchaseable.lowest_priced.second.price rescue nil
  end

  def extra_listings_available?
    listings.purchaseable.count > 1
  end

  # TODO: add 'coupon / discount / etc suffixes'
  def slugify!
    parameterized = title.parameterize

    if Course.where(slug: parameterized).exists?
      parameterized = "#{parameterized}-#{SecureRandom.hex(3)}"
    end

    update(slug: parameterized)
  end
end
