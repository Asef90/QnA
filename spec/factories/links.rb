FactoryBot.define do
  sequence :name do |n|
    "LinkName#{n}"
  end

  factory :link do
    name
    url { "http://www.test-url.com" }

    trait :for_question do
      association :linkable, factory: :question
    end

    trait :for_answer do
      association :linkable, factory: :answer
    end
  end
end
