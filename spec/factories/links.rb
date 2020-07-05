FactoryBot.define do
  sequence :name do |n|
    "LinkName#{n}"
  end

  sequence :url do |u|
    "http://www.test-url-#{u}.com"
  end

  factory :link do
    name
    url

    trait :for_question do
      association :linkable, factory: :question
    end

    trait :for_answer do
      association :linkable, factory: :answer
    end
  end
end
