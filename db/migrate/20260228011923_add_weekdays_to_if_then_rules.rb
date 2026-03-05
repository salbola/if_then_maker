class AddWeekdaysToIfThenRules < ActiveRecord::Migration[7.2]
  def change
    add_column :if_then_rules, :weekdays, :integer, array: true, default: [], null: false
  end
end
