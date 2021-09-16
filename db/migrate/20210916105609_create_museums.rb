class CreateMuseums < ActiveRecord::Migration[6.0]
  def change
    create_table :museums do |t|
      t.string :name
      t.string :address
      t.string :category
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
