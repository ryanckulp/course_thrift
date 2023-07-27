require 'nokogiri'
require 'open-uri'
require 'json'

class CourseScraper
  attr_accessor :course, :site_content

  def initialize(course)
    @course = course
    # PODIA.com only courses for this MVP proof of concept

  end

  def call
    scrape_course_data
    save_course_metadata
  end

  handle_asynchronously :call

  private

  def site_content
    @site_content ||= Nokogiri::HTML(URI.open(course.url))
  end

  def scrape_course_data
    course.update({
      title: title,
      description: description,
      original_price: price,
    })
    attach_featured_image
    course.slugify! # calling it here bc otherwise we are to early when calling from the course modal.. todo: fix this
  end

  def course_data
    site_content.at('[data-react-class="creator_ui/section_adapters/ProductBanner"]')
  end

  def title
    site_content.at_css('meta[property="og:title"]')['content']
  end

  def description
    description_meta = site_content.at_css('meta[name="description"]')
    description_meta['content']
  end

  def price
    return 0 if course_data.nil?
    price_with_dollar_sign.gsub(/[^\d\.]/, '').to_f
  end

  def price_with_dollar_sign
    react_props['prices']['full']
  end

  def react_props
    JSON.parse(course_data['data-react-props'])
  end

  def fetch_image
    react_props["images"]['primary']
  end

  def attach_featured_image
    course.featured_image.attach(io: OpenURI.open_uri(fetch_image), filename: "course_#{course.id}.jpg")
  end
end
