FactoryBot.define do
  factory :listing do
    course { nil }
    user { nil }
    login_username { "MyString" }
    login_password { "MyString" }
    discount_percent { "9.99" }
    published { false }
    sold_at { "2023-07-26 14:49:05" }
    payment_link { "MyString" }
  end
end
