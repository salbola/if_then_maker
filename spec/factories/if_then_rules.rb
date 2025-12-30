FactoryBot.define do
  factory :if_then_rule do
    if_condition { "test_condition" }
    then_action {"test_action"}
  end
end