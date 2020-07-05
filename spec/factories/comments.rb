FactoryBot.define do

  # sequence :body do |b|
  #   "CommentBody#{b}"
  # end

  factory :comment do
    body { "Body" }
    association :author, factory: :user

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
