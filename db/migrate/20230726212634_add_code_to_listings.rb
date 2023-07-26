class AddCodeToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :code, :string
  end
end
