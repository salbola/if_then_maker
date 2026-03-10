class IfThenRule < ApplicationRecord
  belongs_to :user
  belongs_to :memo, optional: true
  has_many :reflections, dependent: :destroy

  enum status: { inactive: 0, active: 1, habituated: 2, draft: 3 }
  validates :if_condition, presence: true, unless: :draft?
  validates :then_action, presence: true, unless: :draft?
  validates :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "if_condition", "memo_id", "status", "then_action", "updated_at", "user_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "memo", "reflections" ]
  end

  def reflected_today?
    @reflected_today ||= reflections.any? { |r| r.reflected_on == Date.current }
  end

  def today_reflection
    @today_feflection ||= reflections.find_by(reflected_on: Date.current)
  end


  # 引数の曜日が設定された曜日にあるのか？
  def scheduled_for?(date)
    return true if weekdays.empty? # 空なら毎日扱い

    weekdays.include?(date.wday)
  end

  # 今日用
  def scheduled_today?
    scheduled_for?(Date.current)
  end

  # 昨日の未達成のもののロジックを必要なら入れるただこのままだとn+1のおそれあり
  # def unfinished_yesterday?
  # scheduled_for?(Date.yesterday) && !!rule.reflections.exists?(reflected_on: Date.yesterday)
  # end

  def human_status
    case status
    when "draft" then "下書き"
    when "inactive" then "停止中"
    when "active" then "実行中"
    when "habituated" then "定着済み"
    end
  end
  def next_schedule
    date = next_scheduled_date

    return {date: date, label: :not_active} unless active?
    return {date: date, label: :no_schedule} unless date #何かしらの理由でnext_scheduled_dateがnilになる場合

    today = Date.current
    return { label: :everyday_reflected } if weekdays.empty? && reflected_today?
    return { label: :everyday } if weekdays.empty?
    return {date: date, label: :today_reflected} if date == today && reflected_today?
    return {date: date, label: :today} if date == today
    return {date: date, label: :tomorrow} if date == today + 1
    # それ以降
    {date: date, label: :later}
  end

private

  def next_scheduled_date
    today = Date.current
    wdays = weekdays # [1,3,5] などの曜日データ
    return today if wdays.empty? #正規化により空配列が毎日なので一応todayを返す
    0.upto(7) do |i|
      date = today + i #今日を基準として１日づつ増やして、データの曜日との一致を検証する
      return date if wdays.include?(date.wday) # 曜日の数字で検証して、一致したらその日を返す
    end

    nil
  end
end
