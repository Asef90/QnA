FactoryBot.define do
  factory :comment do
    commentable { nil }
    author { nil }
    body { "MyString" }
  end
end
