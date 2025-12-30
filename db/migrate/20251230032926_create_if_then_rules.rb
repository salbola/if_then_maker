class CreateIfThenRules < ActiveRecord::Migration[7.2]
  def change
    create_table :if_then_rules do |t|
      t.text :if_condition
      t.text :then_action
      t.integer :status, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :memo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
