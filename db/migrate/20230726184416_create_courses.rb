class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :description
      t.string :url
      t.string :login_url
      t.boolean :published, default: true, null: false
      t.boolean :verified, default: false, null: false
      t.string :category
      t.decimal :original_price

      t.timestamps
    end
  end
end
