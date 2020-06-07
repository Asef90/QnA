FactoryBot.define do
  factory :vote do
    user
    votable { nil }
    value { 1 }

    trait :for_question do
      association :votable, factory: :question
    end
  end
end
