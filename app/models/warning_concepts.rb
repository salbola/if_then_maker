module WarningConcepts
  def self.all
    constants
      .map { |const| const_get(const) }
      .select { |c| c.is_a?(Class) }
  end

  def self.if_concepts
    # all.select(&:if?)
    all.select { |c| c.name.demodulize.start_with?("If") }
  end

  def self.then_concepts
    # all.select(&:then?)
    all.select { |c| c.name.demodulize.start_with?("Then") }
  end
end