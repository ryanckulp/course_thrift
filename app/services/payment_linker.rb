class PaymentLinker
  attr_accessor :listing, :course

  def initialize(listing)
    @listing = listing
    @course = @listing.course
  end

  def call
    create_payment_url
  end
  handle_asynchronously :call

  private

  def create_product
    Stripe::Product.create({ name: course.title })
  end

  def create_price(product)
    Stripe::Price.create({
      currency: 'usd',
      unit_amount: unit_amount, # in cents
      product: product.id
    })
  end

  def create_payment_url
    product = create_product
    price = create_price(product)

    payment_url = Stripe::PaymentLink.create({
      line_items: [
        {
          price: price.id,
          quantity: 1
        }
      ],
      after_completion: {
        type: 'redirect',
        redirect: {
          url: redirect_url
        }
      }
    })

    listing.update(payment_url: payment_url.url)
  end

  def redirect_url
    Rails.application.routes.url_helpers.listing_sold_url(listing.code)
  end

  def unit_amount
    (listing.price * 100).to_i
  end
end
