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

  # 新規作成フォームで使うヘルパー
  # その時のactiveなルールの個数でstatusの入力欄のデフォルト値を変える
  def change_default_status(active_if_then_rules, set_status: nil)
    # もしすでに設定済みの値があればそれを返す(warningやerrorによる再表示用)
    return set_status if set_status
    # activeなルールの個数が3つ以上あれば初期値をdraftにする
    active_if_then_rules.length >= 3 ? "draft" : "active"
  end
end
