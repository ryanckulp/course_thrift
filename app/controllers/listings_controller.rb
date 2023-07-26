class ListingsController < ApplicationController
  before_action :authenticate_user!, except: [:sold]
  before_action :set_listing, only: [:edit]
  before_action :set_listings, only: [:index]
  before_action :set_courses, only: [:new, :edit]

  def new
    @listing = current_user.listings.new
  end

  def edit
  end

  def index
    redirect_to new_listing_path if @listings.count.zero?
  end

  def create
    current_user.update(paypal_address: params[:paypal_address]) if params[:paypal_address].present?
    listing = current_user.listings.new(listing_params)

    if listing.save
      redirect_to course_path(listing.course.slug)
    else
      redirect_to new_listing_path, alert: 'Sorry, something went wrong.'
    end
  end

  def update
  end

  def destroy
  end

  def sold
    listing = Listing.find_by_code(params[:code])

    if listing
      listing.mark_sold!
      redirect_to course_path(listing.course.slug), notice: 'Congrats! Credentials will be in your inbox shortly.'
    else
      redirect_to root_path, alert: 'Sorry, something went wrong.'
    end
  end

  private

  def set_listing
    @listing = current_user.listings.find(params[:id])
  end

  def set_listings
    @listings = current_user.listings
  end

  def set_courses
    @courses = Course.published
  end

  def listing_params
    params.require(:listing).permit(:course_id, :login_username, :login_password, :discount_percent)
  end
end
