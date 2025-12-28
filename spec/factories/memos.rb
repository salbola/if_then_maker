FactoryBot.define do
  factory :memo do
    title { "test_title" }

    body { "body"*10 }
  end
end
