class MoviesController < ApplicationController

  include SlackNotification
  before_action :set_movie, only: [:show, :update, :destroy, :add_to_favorite]
  before_action :authenticate_api_user!, except: [ :index, :show ]

  # MAX_PAGINATION_LIMIT = 10

  def index
    # @movies = Movie.limit(limit).offset(params[:offset]).order(title: :asc)
    @movies = Movie.page(page).per(per_page).order(title: :asc)

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

    # def limit
    #     [
    #       params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
    #       MAX_PAGINATION_LIMIT
    #     ].min
    # end

    def page
     @page ||= params[:page] || 1
    end

    def per_page
      @per_page ||= params[:per_page] || 5
    end

    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:title, :year, :genre, :rated, :release, :runtime, :type, :user_id, :image)
    end

    def pagination_meta(object)        
      {       
     current_page: object.current_page,        
     next_page: object.next_page,        
     prev_page: object.prev_page,        
     total_pages: object.total_pages,        
     total_count: object.total_count        }    
   end
end
