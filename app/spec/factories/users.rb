FactoryBot.define do
  factory :user do
    name { Faker::Name.initials }
    sequence(:email) { "user_#{_1}@example.com" }
    password { "password" }
    profile { "examples" }
    blog_url { "http://example.com" }
  end
end
