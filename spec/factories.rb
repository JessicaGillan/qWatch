FactoryGirl.define do

  factory :watchable do

    sequence(:tmdb_id) { |n| n }

    tmdb_type "movie"
    sequence(:title) { |n| "Title #{n}" }

  end

  factory :tmdb_config, class: TMDBConfig do

    url "http://image.tmdb.org/t/p/"
    secure_url "https://image.tmdb.org/t/p/"
    sizes ["h632", "original", "w1280", "w154", "w185", "w300", "w342", "w45", "w500", "w780", "w92"]

  end

  factory :user do
    name  'Bobby Tables'
    sequence(:email) { |n| "test#{n}@example.com" }
    password    'password'
  end

end
