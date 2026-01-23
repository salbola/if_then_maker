module WarningConcepts
  def self.all
    constants
      .map { |const| const_get(const) }
      .select { |c| c.is_a?(Class) }
  end

  def self.if_concepts
    all.select { |c| c.definition[:target] == :if }
  end

  def self.then_concepts
    all.select { |c| c.definition[:target] == :then }
  end
end