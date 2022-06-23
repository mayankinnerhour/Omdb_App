class MoviesController < ApplicationController

  include SlackNotification
  before_action :set_movie, only: [:show, :update, :destroy, :add_to_favorite]
  before_action :authenticate_api_user!, except: [ :index, :show ]

  def index
    @movies = Movie.all

    render json: @movies
  end

  def show

    @reviews = Review.where(movie_id: @movie.id).order("created_at DESC")
    
    if @reviews.blank?
      @avg_review = 0
      render json: @reviews
    else
      @avg_review = @reviews.average(:rating).round(2)
      render json: @avg_review
    end
    # render json: @reviews
  end

  def create
    @movie = current_api_user.movies.build(movie_params)
    # @movie = Movie.new(movie_params)
    if @movie.save
      render json: @movie, status: :created, location: @movie
      message = "A new movie #{@movie.title} has been successfully Added!"
    else
      render json: @movie.errors, status: :unprocessable_entity
      message = "Movie #{@movie.title} Failed to add."
    end
    slack_data = { message: message }
    sendNotification(slack_data)
  end

  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    render json: "Deleted Successfully"
  end

  def add_to_favorite
    type = params[:type]
    if type == "favorite"
      current_api_user.favorites << @movie
      render json: @movie, message: "Added to Favorites", status: :created, location: @movie
      message = "A new movie #{@movie.title} has been successfully Added to Favorites"
    elsif type == "unfavorite"
      current_api_user.favorites.delete(@movie)
      render json: @movie, message: "Removed from Favorites", status: :created, location: @movie
      message = "Movie #{@movie.title} has been successfully Removed from Favorites"
    else
      render json: @movie, message: "Nothing Happend."
    end

    slack_data = { message: message }
    sendNotification(slack_data)

    # p "All Favorite Movies"
    # return current_api_user.favorites(type: "favorite")
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:title, :year, :genre, :rated, :release, :runtime, :type, :user_id, :image)
    end
end
