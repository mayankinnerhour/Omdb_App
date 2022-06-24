class Movie < ApplicationRecord
	include SlackNotification

	# searchkick

	belongs_to :user
	has_many :favorite_movies
	has_many :favorited_by, through: :favorite_movies, source: :user # the actual users favoriting a movie
	has_many :reviews
	has_one_attached :image

	validates :title, presence: true
	validates :description, length: { maximum: 1000, too_long: "%{count} characters is the maximum allowed" }
	validates :year, numericality: { only_integer: true }
	validates :starts_at, presence: true

	scope :with_long_title, ->(length = 10) { where("LENGTH(title) > ?", length) }
	scope :new_movies, ->(latest = 2022) {where("year >= ?", latest)}
	scope :only_movies, ->(type = "series") {where("description = ?", type) }

	after_create :reminder

	def reminder
		time_str = ((self.starts_at).localtime).strftime("%I:%M%p on %b. %d, %Y")
		message = "Movie #{self.title}. Just a reminder that you have a movie coming up at #{time_str} to watch."
		slack_data = { message: message }
		sendNotification(slack_data)
	end

	def when_to_run
		minutes_before_movie = 1.minutes
		starts_at - minutes_before_movie
	end

	handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }
end
