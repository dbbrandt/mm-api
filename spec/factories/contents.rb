# spec/factories/contents.rb
FactoryGirl.define do
  factory :content do
    title { Faker::Lorem.word }
    content_type { "Prompt" }
    description { Faker::Lorem.word }
    copy { Faker::Lorem.word }
    interaction { }
  end
end
