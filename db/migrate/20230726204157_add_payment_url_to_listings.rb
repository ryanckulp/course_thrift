class AddPaymentUrlToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :payment_url, :string
  end
end
