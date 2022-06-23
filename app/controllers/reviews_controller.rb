class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :update, :destroy]
  before_action :set_movie
  before_action :authenticate_api_user!, except: [ :index, :show ]


  def index
    @reviews = Review.all

    render json: @reviews
  end

  def show
    render json: @review
  end

  def create
    @review = current_api_user.reviews.build(review_params)
    @review.user_id = current_api_user.id
    @review.movie_id = @movie.id

    if @review.save
      render json: @review, status: :created, location: @movie
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    render json: "Deleted Successfully"
  end

  private
    def set_review
      @review = Review.find(params[:id])
    end

    def set_movie
      @movie = Movie.find(params[:movie_id])
    end

    def review_params
      params.require(:review).permit(:rating, :comment, :user_id, :movie_id)
    end
end
