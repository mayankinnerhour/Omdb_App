class Review < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :rating, presence: true
  validates :comment, length: { maximum: 100, too_long: "%{count} characters is the maximum allowed" }
  validates :rating, numericality: { only_integer: true }
end
