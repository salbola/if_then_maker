FactoryBot.define do
  factory :authentication do
    association :user
    provider { "google" }
    sequence(:uid) { |n| "google-uid-#{n}" }
  end
end
