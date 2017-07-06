# spec/factories/interactions.rb
FactoryGirl.define do
  factory :import_file do
    title { Faker::Lorem.word }
    json_data { [{'title': Faker::Lorem.word,'answer_type': 'ShortAnswer'}] }
  end
end