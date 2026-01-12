class IfThenRuleForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :memo_id, :integer
  attribute :if_condition, :string
  attribute :then_action, :string
  attribute :status, :string
  #モデルにおいてstatusはintだがenum
  validates :if_condition, presence: { message: "IF（きっかけ）を入力してください" }
  validates :then_action, presence: { message: "THEN（行動）を入力してください" }

  attr_reader :warnings
  attr_reader :user
  attr_reader :if_then_rule_of_model

  def initialize(attributes = {}, user:, if_then_rule_of_model: nil)
    super(attributes)
    @warnings = []
    @if_then_rule_of_model = if_then_rule_of_model
    @current_user = user
  end

  def valid?(context = nil)
    result = super
    build_warnings
    result
  end

  def savable?(ignore_warnings: false)
    valid? && (warnings.blank? || ignore_warnings)
  end

  def save(ignore_warnings: false)
    return false unless savable?(ignore_warnings: ignore_warnings)

    if @if_then_rule_of_model
      #モデルが渡されている場合はeditからの文脈なのでupdateの処理
      update_rule
    else
      #モデルが渡されてない場合はnewからの文脈なのでupdateの処理
      create_rule
  end
    
  end

  def apply_model_to_form
      #モデルが渡されている場合は属性の値入っていなければモデルのものになる(edit表示用にコントローラーで使う)
      return false unless @if_then_rule_of_model
      self.memo_id      = if_then_rule_of_model.memo_id
      self.if_condition = if_then_rule_of_model.if_condition
      self.then_action  = if_then_rule_of_model.then_action
      self.status  = if_then_rule_of_model.status
  end


  private

  def build_warnings
    @warnings = []
    @warnings += ::IfConditionWarningChecker.check(if_condition)
    @warnings += ::IfConditionDuplicateChecker.check(
      user: @current_user,
      if_condition: if_condition,
      #編集時=>モデルが渡されている時=>@if_then_rule_of_modelがある時はそのidを無視するため
      exclude_id: @if_then_rule_of_model&.id
    )
    @warnings += ::ThenActionWarningChecker.check(then_action)
    add_active_limit_warning
  end

  def create_rule
      record = @current_user.if_then_rules.create(
      memo_id: memo_id,
      if_condition: if_condition,
      then_action: then_action
    )
     record.persisted?
  end

  def update_rule
    @if_then_rule_of_model.update(
      memo_id: memo_id,
      if_condition: if_condition,
      then_action: then_action,
      status: status
    )
  end

  def add_active_limit_warning
  return unless status == "active"

  # 編集時：すでに active ならスキップ(activeのレコードの時にactiveを送信することによる意図しないwarningの発生を防ぐ)
  if @if_then_rule_of_model
    return if @if_then_rule_of_model.status == "active"
  end

  active_count = @current_user.if_then_rules.active.count
  return unless active_count >= 3

  @warnings << "実行中（active）のルールがすでに3つあります。負担が大きくなっていないか確認してみてください。"
end
end
