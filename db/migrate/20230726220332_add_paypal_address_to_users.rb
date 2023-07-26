class AddPaypalAddressToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :paypal_address, :string
  end
end
