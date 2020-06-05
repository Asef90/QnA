FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body
    best_mark { false }
    association :question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
