

# puts "Populating all Movie titles from movie_api"
#
# MovieSyncer.populate_db_titles
#
# puts "Done"


puts "destroying users and Viewings"

User.destroy_all
Viewing.destroy_all

puts "adding users"

10.times do |i|
  User.create({
    name: "user#{i}",
    email: "u#{i}@example.com",
    password: "111111",
    password_confirmation: "111111",
  })
end

puts "creating facebook accounts for users"

User.all.each_with_index do |user, index|
  user.authentications.create(provider: "facebook", uid: index)
end

puts "adding viewings to users"

watchables = Watchable.all.limit(100)

User.all.each do |u|
  5.times do |i|
    u.viewed_items << watchables[u.id + i]
  end
end
