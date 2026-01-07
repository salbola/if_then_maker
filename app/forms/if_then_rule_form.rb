class IfThenRuleForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :memo_id, :integer
  attribute :if_condition, :string
  attribute :then_action, :string

  validate :if_condition, :then_action, presence: true
  
  attr_reader :warnings

  def initialize(attributes = {})
    super
    @warnings = []
  end

  def valid?(context = nil)
    result = super
    result
  end

  def save
    return false unless valid?

    IfThenRule.create!(
      memo_id: memo_id,
      if_condition: if_condition,
      then_action: then_action
    )
  end

end