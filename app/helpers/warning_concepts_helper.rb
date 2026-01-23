module WarningConceptsHelper
  def if_concepts
    WarningConcepts.if_concepts
  end

  def then_concepts
    WarningConcepts.then_concepts
  end
end