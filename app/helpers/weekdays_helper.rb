module WeekdaysHelper

  #曜日をカードで表示するためのヘルパー
  # 毎日か設定されている曜日を表示する
  def weekdays_label(weekdays)
    return "毎日" if weekdays.blank?

    t_names = I18n.t("date.abbr_day_names")

    weekdays.map {|i| t_names[i]}.join("・")
  end

end