module IfThenRulesHelper
# ダッシュボードの"今日の達成率"で使用するヘルパー
  def today_progress(if_then_rules)
    active = if_then_rules.active
    total  = active.count
    done   = active.count(&:reflected_today?)

    {
      total: total,
      done: done,
      percent: total.zero? ? 0 : (done * 100 / total)
    }
  end
# ルールをカード表示する際のヘルパー
  def if_then_rule_board_view(rule)
    safe_join([
      tag.p(rule.if_condition, class: "font-normal"),
      tag.p(rule.then_action, class: "font-semibold text-primary mt-4")
    ])
  end

# 新規作成フォームで使うヘルパー
  # その時のactiveなルールの個数でstatusの入力欄のデフォルト値を変える
  def change_default_status(active_if_then_rules, setted_status: nil)
    # もしすでに設定済みの値があればそれを返す(warningやerrorによる再表示用)
    return setted_status if setted_status
    # activeなルールの個数が3つ以上あれば初期値をdraftにする
    active_if_then_rules.length >= 3 ? "draft" : "active"
  end
end