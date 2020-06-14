FactoryBot.define do
  factory :comment do
    commentable { nil }
    author { nil }
    body { "MyString" }

    trait :invalid do
      body { nil }
    end
    
    trait :for_question do
      association :commentable, factory: :question
    end

    trait :for_answer do
      association :commentable, factory: :answer
    end
  end
end
