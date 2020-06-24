FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { "MyString" }
    uid { "MyString" }
    token { nil }
    confirmed { false }

    trait :empty do
      provider { nil }
      uid { nil }
    end
  end


end
