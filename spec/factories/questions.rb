FactoryBot.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  factory :question do

    association :author, factory: :user
    title
    body { "QuestionBody" }

    trait :with_reward do
      after(:create) { |question| create(:reward, question: question) }
    end

    trait :invalid do
      title { nil }
    end
  end
end
