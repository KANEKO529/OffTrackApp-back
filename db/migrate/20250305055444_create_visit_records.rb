class CreateVisitRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :visit_records do |t|
      t.date :date
      t.string :store_name
      t.float :latitude
      t.float :longitude
      t.text :memo

      t.timestamps
    end
  end
end
