# spec/factories/interactions.rb
FactoryGirl.define do
  factory :interaction do
    name { Faker::Lorem.word }
    type "ShortAnswer"
    goal_id nil
  end
end