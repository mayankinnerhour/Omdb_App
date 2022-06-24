require 'json'
require 'open-uri'

# url = 'http://www.omdbapi.com?apikey=c9feda2c&s=lov&page=3'
# movie_id = URI.open(url).read
# # p movie_id
# movies = JSON.parse(movie_id)

5.times do |index|
	# movie_id = movies[index]
	url_movie = "http://www.omdbapi.com?apikey=c9feda2c&s=lov&page=#{index+1}"
	movie_info = URI.open(url_movie).read
	movie = JSON.parse(movie_info)
	movie["Search"].present? && movie["Search"].each do |m|
	new_movie = Movie.create!(
		title: m["Title"],
		description: m["Type"],
		runtime: m["Runtime"],
		genre: m["Director"],
		rated: m["Ratings"],
		year: m["Year"],
		user_id: 1
		)
end

	# p new_movie
end