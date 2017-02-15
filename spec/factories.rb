FactoryGirl.define do

  factory :watchable do

    sequence(:tmdb_id) { |n| n }

    tmdb_type "movie"
    sequence(:title) { |n| "Title #{n}" }

  end

  factory :tmdb_config do

    url "http://image.tmdb.org/t/p/"

  end

end
