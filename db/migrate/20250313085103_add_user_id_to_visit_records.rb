class AddUserIdToVisitRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :visit_records, :user_id, :bigint, null: true
    add_index :visit_records, :user_id
    add_foreign_key :visit_records, :users, on_delete: :cascade
  end
end
