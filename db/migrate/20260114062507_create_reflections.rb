class CreateReflections < ActiveRecord::Migration[7.2]
  def change
    create_table :reflections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :if_then_rule, null: false, foreign_key: true
      t.date :reflected_on, null: false

      t.timestamps

      t.index [:user_id, :if_then_rule_id, :reflected_on],
      unique: true,
      name: "index_reflections_on_user_rule_and_date"
    end
  end
end
