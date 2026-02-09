class TrialRuleForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :memo_id, :integer
  attribute :if_condition, :string
  attribute :then_action, :string
  attribute :status, :string
  # モデルにおいてstatusはintだがenum
  validates :if_condition, presence: { message: "IF（きっかけ）を入力してください" }
  validates :then_action, presence: { message: "THEN（行動）を入力してください" }

  attr_reader :warnings
  # attr_reader :if_then_rule_of_model

  def initialize(attributes = {})
    super(attributes)
    @warnings = []
  end

  def valid?(context = nil)
    result = super
    collect_warnings
    result
  end

  def savable?(ignore_warnings: false)
    valid? && (warnings.blank? || ignore_warnings)
  end

  # def save(ignore_warnings: false)
  # return false unless savable?(ignore_warnings: ignore_warnings)
  # trialでは保存はしない
  # if @if_then_rule_of_model
  #   # モデルが渡されている場合はeditからの文脈なのでupdateの処理
  #   update_rule
  # else
  #   # モデルが渡されてない場合はnewからの文脈なのでupdateの処理
  #   create_rule
  # end
  # end

  # def apply_model_to_form
  #     # モデルが渡されている場合は属性の値入っていなければモデルのものになる(edit表示用にコントローラーで使う)
  #     return false unless @if_then_rule_of_model
  #     self.memo_id      = if_then_rule_of_model.memo_id
  #     self.if_condition = if_then_rule_of_model.if_condition
  #     self.then_action  = if_then_rule_of_model.then_action
  #     self.status  = if_then_rule_of_model.status
  # end

  # ↓ビュー(_form.html.erb)で使うwarningメッセージ集を取得するためのメソッド。
  # @warningにはメッセージは入っていないがキーと今回検出されたキーワードが存在。
  # そのキーと紐づけた素材、warning_conceptsにあるメッセージや検出されたワードを組み合わせる。
  # それを配列としてwarningメッセージのパーツの塊の集まりとして返す
  def warning_messages
    @warnings.map do |w|
      Warnings::WarningMessageBuilder.build(w)
    end
  end
  private

  def collect_warnings
    # 編集時と新規作成で挙動が変化するものは編集前の元のルールである@if_then_rule_of_modelを渡す。
    @warnings = []
    @warnings += Warnings::IfAmbiguousTriggerExpressionChecker.check(if_condition)
    @warnings += Warnings::IfUnobservableTriggerChecker.check(if_condition)
    @warnings += Warnings::ThenNonVerifiableActionChecker.check(then_action)
    @warnings += Warnings::ThenOversizedActionChecker.check(then_action)
    @warnings += Warnings::ThenNegativeExpressionActionChecker.check(then_action)
    # 以下,他のレコードが関わる構成系
    # userが関わるcheckerはtrialでは機能しないので停止
    # @warnings += Warnings::IfDuplicateContentChecker.check(
    #   user: @current_user,
    #   if_condition: if_condition,
    #   exclude_id: @if_then_rule_of_model&.id
    # )
    # @warnings += Warnings::StatusTooManyActiveChecker.check(user: @current_user, status: status, current_rule: @if_then_rule_of_model)
  end

  # trialでは使用しない
  # def create_rule
  #     record = @current_user.if_then_rules.create(
  #     memo_id: memo_id,
  #     if_condition: if_condition,
  #     then_action: then_action,
  #     status: status
  #   )
  #    record.persisted?
  # end

  # trialでは使用しない
  # def update_rule
  #   @if_then_rule_of_model.update(
  #     memo_id: memo_id,
  #     if_condition: if_condition,
  #     then_action: then_action,
  #     status: status
  #   )
  # end
end
