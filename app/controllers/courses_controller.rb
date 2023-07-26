class CoursesController < ApplicationController
  def index
    @courses = Course.published
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
  end

  def create
    course = Course.new(course_params)
    if course.save
      redirect_to course_path(course.id)
    else
      redirect_to new_course_path
    end
  end

  private

  def course_params
    params.require(:course).permit(:url)
  end
end
