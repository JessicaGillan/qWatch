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

  factory :user, aliases: [:friend_initiator, :friend_recipient] do
    name  'Bobby Tables'
    sequence(:email) { |n| "test#{n}@example.com" }
    password    'password'

    factory :user_with_friends do

      transient do
        friends_count 0
      end

      after(:create) do |user, evaluator|
        create_list(:friending, evaluator.friends_count, friend_initiator: user)
      end

    end

    factory :user_with_fb_account do
      after(:create) do |user|
        create(:user_authentication, user: user)
      end
    end
  end

  factory :friending do
    friend_initiator
    friend_recipient
  end

  factory :user_authentication do
    user

    provider "facebook"
    sequence(:uid){ |n| n }
  end
end
