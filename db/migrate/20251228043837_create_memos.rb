class CreateMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :memos do |t|
      t.string :title, null: false
      t.text :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
