class IfThenRuleForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :memo_id, :integer
  attribute :if_condition, :string
  attribute :then_action, :string

  validates :if_condition, :then_action, presence: true

  attr_reader :warnings
  attr_reader :user

  def initialize(attributes = {}, user:)
    super(attributes)
    @warnings = []
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

      record=@current_user.if_then_rules.create(
      memo_id: memo_id,
      if_condition: if_condition,
      then_action: then_action
    )
    if record.persisted?
        # 一応trueかfalseを返す形式に整えておく
        true
    else
        false
    end
  end


  private

  def build_warnings
    @warnings = []
    @warnings += ::IfConditionWarningChecker.check(if_condition)
    @warnings += ::IfConditionDuplicateChecker.check(
      user: @current_user,
      if_condition: if_condition
    )
  end
end
