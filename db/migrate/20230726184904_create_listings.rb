class CreateListings < ActiveRecord::Migration[7.0]
  def change
    create_table :listings do |t|
      t.references :course, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :login_username
      t.string :login_password
      t.decimal :discount_percent
      t.boolean :published, default: false, null: false
      t.datetime :sold_at
      t.string :payment_link

      t.timestamps
    end
  end
end
