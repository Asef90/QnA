FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body
    best_mark { false }
    association :question

    trait :invalid do
      body { nil }
    end
  end
end
