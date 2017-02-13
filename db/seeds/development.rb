
puts "Deleting database"

Watchable.destroy_all

puts "Populating all Movie titles from movie_api"

Movie.populate_db_titles

puts "Add url info to all Movie titles, for #{Watchable.count} movies"

Movie.populate_watchables_data

puts "Done"
