module WarningConceptsHelper
  def self.if_concepts
    WarningConcepts.all.select { |c| c.name.demodulize.start_with?("If") }
  end

  def self.then_concepts
    WarningConcepts.all.select { |c| c.name.demodulize.start_with?("Then") }
  end
end