class ActiveLimitWarningChecker
  LIMIT = 3
  # currnt_ruleがnilの場合新規作成としてるのでこれだけは必須ではない
  def self.check(user:, status:, current_rule: nil)
    return [] unless status == "active"

    # 編集時：すでに active ならスキップ
    if current_rule&.status == "active"
      return []
    end

    active_count = user.if_then_rules.active.count
    return [] unless active_count >= LIMIT

    [ {
      field: :status,
      message: "実行中（active）のルールがすでに#{LIMIT}つあります。負担が大きくなっていないか確認してみてください。"
    } ]
  end
end
