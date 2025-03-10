class RemoveStoreNameFromVisitRecords < ActiveRecord::Migration[7.1]
  def change
    remove_column :visit_records, :store_name, :string
    add_column :visit_records, :price, :integer
  end
end
