class CoursesController < ApplicationController
  before_action :set_course, only: [:show]

  def index
    @courses = Course.purchaseable
  end

  def show
    @listing = @course.listings.purchaseable.lowest_priced.first
  end

  def new
    @course = Course.new
  end

  def create
    course = Course.new(course_params)
    if course.save
      redirect_to new_listing_path
    else
      redirect_to new_course_path
    end
  end

  private

  def course_params
    params.require(:course).permit(:url)
  end

  def set_course
    @course = Course.find_by_slug(params[:id])
  end
end
