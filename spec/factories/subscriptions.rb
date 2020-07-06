FactoryBot.define do
  factory :subscription do
    user

    trait :on_question do
      association :subscriptable, factory: :question
    end
  end
end
