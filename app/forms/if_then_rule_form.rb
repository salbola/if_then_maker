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

  def save
    return false unless valid?

      record=@current_user.if_then_rules.create(
      memo_id: 16,
      if_condition: if_condition,
      then_action: then_action
    )
    if record.persisted?
        true
      else
        false
    end

  end


  private
  
  def build_warnings
    @warnings = []
    @warnings += ::IfConditionWarningChecker.check(if_condition)
  end
end