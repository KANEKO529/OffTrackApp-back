class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :nickname, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true # ここで一意制約を設定
  end
end

