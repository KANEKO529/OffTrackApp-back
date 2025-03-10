class ModifyVisitRecords < ActiveRecord::Migration[7.1]
  def change
    remove_column :visit_records, :latitude, :float
    remove_column :visit_records, :longitude, :float
    add_reference :visit_records, :store, foreign_key: true
  end
end
