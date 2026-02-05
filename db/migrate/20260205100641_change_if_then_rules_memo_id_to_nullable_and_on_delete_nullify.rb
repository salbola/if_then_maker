class ChangeIfThenRulesMemoIdToNullableAndOnDeleteNullify < ActiveRecord::Migration[7.2]
  def change
    # null許可
    change_column_null :if_then_rules, :memo_id, true

    # 既存FK削除
    remove_foreign_key :if_then_rules, :memos

    # ON DELETE SET NULL 付きで再追加
    add_foreign_key :if_then_rules, :memos, on_delete: :nullify
  end
end
