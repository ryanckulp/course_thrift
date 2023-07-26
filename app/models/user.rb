class User < ApplicationRecord
  include Signupable
  include Onboardable
  include Billable

  has_many :listings, dependent: :destroy

  scope :subscribed, -> { where(paying_customer: true) }
end
