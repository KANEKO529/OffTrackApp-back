class ChangeDateToDatetimeInVisitRecords < ActiveRecord::Migration[7.1]
  def change
    change_column :visit_records, :date, :datetime
  end
end
