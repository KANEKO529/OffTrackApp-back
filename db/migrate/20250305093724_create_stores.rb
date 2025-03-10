class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.string :store_name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
