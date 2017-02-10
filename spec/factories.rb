FactoryGirl.define do

  factory :watchable do

    sequence(:gb_id) do |n|
      n
    end

    gb_type "movie"
    title "Title"

  end

  factory :poster do

    watchable
    thumbnail "thumbnail"
    medium "medium"
    large "large"

  end

end
