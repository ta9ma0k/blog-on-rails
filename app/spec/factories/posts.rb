FactoryBot.define do
  factory :post do
    body { "examples" }
    posted_at { Time.zone.now }
  end
end
