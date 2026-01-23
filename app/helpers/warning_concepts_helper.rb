module WarningConceptsHelper
  def if_concepts
    WarningConcepts.all.select { |c| c.name.demodulize.start_with?("If") }
  end

  def then_concepts
    WarningConcepts.all.select { |c| c.name.demodulize.start_with?("Then") }
  end
end