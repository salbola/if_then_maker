class ChangeTitleNullOnMemos < ActiveRecord::Migration[7.2]
  def change
    change_column_null :memos, :title, true
  end
end
