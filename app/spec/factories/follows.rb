FactoryBot.define do
  factory :follow do
    association :user
    association :followee, factory: :user
  end
end
