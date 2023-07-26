# PODIA.com only courses for this MVP proof of concept
class CourseScraper
  attr_accessor :browser, :course

  def initialize(course)
    @browser = new_browser
    @course = course
  end

  def call
    load_course
    save_params
    close_browser
  end
  handle_asynchronously :call

  private

  def load_course
    browser.goto(course.url)
    browser.scroll.to(:bottom)
  end

  def save_params
    course.update({
      title: title,
      description: description,
      original_price: price,
    })

    course.slugify!
    course.featured_image.attach(io: OpenURI.open_uri(image), filename: "course_#{course.id}.jpg")
  end

  def close_browser
    browser.close
  end

  def title
    browser.meta(property: 'og:title').content
  end

  def description
    browser.meta(name: 'description').content
  end

  def price
    begin # happy path
      enroll_btn = browser.a(href: /\/buy\?payment_terms=full/).text # => "Buy for $2,500"
      enroll_btn.split("Buy for $")[-1].delete(',').to_f # handles "Get access for free" OK
    rescue => e
      puts "ERROR while finding price."
    end
  end

  def image
    browser.meta(property: 'og:image').content
  end

  def image_io
    OpenURI.open_uri(image)
  end

  def new_browser
    # removed for local testing: --remote-debugging-port=9222
    Watir::Browser.new browser_profile, options: { args:  %w[--headless --no-sandbox --disable-dev-shm-usage --disable-gpu] }
  end

  def browser_profile
    return :firefox if Rails.env.development?
    :chrome
  end
end
