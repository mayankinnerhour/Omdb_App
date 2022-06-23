class Movie < ApplicationRecord
	# include SlackNotification

	# searchkick

	belongs_to :user
	has_many :favorite_movies
	has_many :favorited_by, through: :favorite_movies, source: :user # the actual users favoriting a movie
	has_many :reviews
	# has_one_attached :image


	# after_create :reminder

	# scope :by_name, -> (keyword) { any_of({ :title => /.*#{keyword}.*/ }) if keyword.present? }
	# scope :old, -> { where('year < ?', 1.years.ago )}

	# def reminder
	# 	time_str = ((self.time).localtime).strftime("%I:%M%p on %b. %d, %Y")
	# 	message = "Movie #{self.title}. Just a reminder that you have a movie coming up at #{time_str} to watch."
	# 	slack_data = { message: message }
	# 	sendNotification(slack_data)
	# end

	# def when_to_run
	# 	minutes_before_movie = 1.minutes
	# 	time - minutes_before_movie
	# end

	# handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }
end
