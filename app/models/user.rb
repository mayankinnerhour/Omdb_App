# frozen_string_literal: true

class User < ActiveRecord::Base

  extend Devise::Models #added this line to extend devise model

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :movies
  has_many :favorite_movies
  has_many :favorites, through: :favorite_movies, source: :movie # the actual movies a user favorites
  has_many :reviews, dependent: :destroy

end
