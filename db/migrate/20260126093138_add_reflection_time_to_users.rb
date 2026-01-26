class AddReflectionTimeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :reflection_time, :time
  end
end
