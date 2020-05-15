FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body
    association :question

    trait :invalid do
      body { nil }
    end
  end
end
