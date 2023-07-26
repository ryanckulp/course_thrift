class Listing < ApplicationRecord
  belongs_to :course
  belongs_to :user

  scope :with_payment_url, -> { where.not(payment_url: nil) }
  scope :lowest_priced, -> { order(discount_percent: :desc) }
  scope :unsold, -> { where(sold_at: nil) }
  scope :purchaseable, -> { unsold.with_payment_url }

  before_create :generate_code
  after_create_commit :create_payment_url

  def generate_code
    self.code = SecureRandom.hex(4)
  end

  def create_payment_url
    PaymentLinker.new(self).call
  end

  def price
    course.original_price.to_f - (course.original_price.to_f * (discount_percent.to_f / 100))
  end

  def mark_sold!
    update(sold_at: DateTime.now)
  end
end
