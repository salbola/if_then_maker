module IfThenRulesHelper
  # ダッシュボードの"今日の達成率"で使用するヘルパー
  def today_progress(today_rules)
    active = today_rules
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

  # ステータスのバッジ表示においてその色をステータスごとに変えるヘルパー
  def status_color_class(status)
    case status
    when "draft" then "bg-teal-500 "
    when "inactive" then "bg-gray-500 "
    when "active" then "bg-sky-500 "
    when "habituated" then "bg-slate-900 "
    end
  end


  def checked_status_class(status)
    case status
    when "draft" then "has-[:checked]:bg-teal-500 has-[:checked]:outline-teal-500 has-[:checked]:font-semibold has-[:checked]:text-white"
    when "inactive" then "has-[:checked]:bg-gray-500 has-[:checked]:outline-gray-500 has-[:checked]:font-semibold has-[:checked]:text-white"
    when "active" then "has-[:checked]:bg-sky-500 has-[:checked]:outline-sky-500 has-[:checked]:font-semibold has-[:checked]:text-white"
    when "habituated" then "has-[:checked]:bg-slate-900 has-[:checked]:outline-slate-900 has-[:checked]:font-semibold  has-[:checked]:text-white"
    end
  end

    # そのルールの設定曜日に基づいた次回曜日のヘルパー
    def next_schedule_label(rule)
      next_schedule = rule.next_schedule
      date = next_schedule[:date]
      return "ステータスが実行中ではありません" if next_schedule[:label] == :not_active
      return "予定なし" if next_schedule[:label] == :no_schedule

      today = Date.current

      return "毎日(実行済み)" if next_schedule[:label] == :everyday_reflected
      return "毎日" if next_schedule[:label] == :everyday
      return "今日(実行済み)" if next_schedule[:label] == :today_reflected
      return "今日" if next_schedule[:label] == :today
      return "明日" if next_schedule[:label] == :tomorrow
      # それ以降はその日付を返す
      I18n.l(date, format: :short)
    end
end
