class CourseScraper
  attr_accessor :course, :doc
  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def initialize(course)
    @course = course
    # PODIA.com only courses for this MVP proof of concept
  end

  def call
    save_course
  end

  handle_asynchronously :call

  private


  def doc
    @doc ||= Nokogiri::HTML(URI.open(course.url)) # make it memoized so we don't have to keep hitting the URL
  end

  def save_course
    course.update({
      title: title,
      description: description,
      original_price: price,
    })

    course.slugify!
    course.featured_image.attach(io: OpenURI.open_uri(image), filename: "course_#{course.id}.jpg")
  end


  def title
    title = doc.at_css('meta[property="og:title"]')['content']
  end

  def description
    description_meta = doc.at_css('meta[name="description"]')
    description_content = description_meta['content']
  end

  def price
    element = doc.at('[data-react-class="creator_ui/section_adapters/ProductBanner"]')

    return 0 if element.nil?

    react_props = JSON.parse(element['data-react-props'])
    price_with_dollar_sign = react_props['prices']['full']
    price = price_with_dollar_sign.gsub(/[^\d\.]/, '').to_f

  end

  def image
    element = doc.at('[data-react-class="creator_ui/section_adapters/ProductBanner"]')

    react_props = JSON.parse(element['data-react-props'])
    images = react_props["images"]

    images['primary']
  end

end
