FactoryBot.define do
  factory :course do
    title { "MyString" }
    description { "MyString" }
    url { "MyString" }
    login_url { "MyString" }
    published { false }
    verified { false }
    category { "MyString" }
    original_price { "9.99" }
  end
end
