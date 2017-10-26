# spec/factories/import_rows.rb
FactoryGirl.define do
  factory :import_row do
    title { Faker::Lorem.word }
    json_data { "{\"title\": \"#{Faker::Lorem.word}\",\"answer_type\": \"ShortAnswer\",\"prompt\": #{Faker::Lorem.sentences(1)},\"criterion1\": #{Faker::Lorem.sentences(1)},\"copy1\": #{Faker::Lorem.sentences(1)},\"points1\": \"1\"}" }
    import_file { }
  end
end