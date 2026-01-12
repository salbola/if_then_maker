FactoryBot.define do
  factory :if_then_rule do
    sequence(:if_condition) { |n| "test_condition_#{n}" }
    then_action { "test_action" }
  end
end
