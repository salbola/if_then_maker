module WarningConcepts
  def self.all
    constants
      .map { |const| const_get(const) }
      .select { |c| c.is_a?(Class) }
  end
end