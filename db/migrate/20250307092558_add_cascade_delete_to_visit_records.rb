class AddCascadeDeleteToVisitRecords < ActiveRecord::Migration[7.1]
  def change
    # 既存の外部キーを削除
    remove_foreign_key :visit_records, :stores

    # `on_delete: :cascade` を適用した新しい外部キーを追加
    add_foreign_key :visit_records, :stores, on_delete: :cascade
  end
end
