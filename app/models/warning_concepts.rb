module WarningConcepts
  def self.all
    constants
      .map { |const| const_get(const) }
      .select { |c| c.is_a?(Class) }
  end
# メソッド名で分けるタイプ
  def self.if_concepts
    all.select { |c| c.definition[:target] == :if }
  end

  def self.then_concepts
    all.select { |c| c.definition[:target] == :then }
  end
# 引数でtarget指定してもってくる
  def self.for_target(target)
  all.select { |c| c.definition[:target] == target }
  end
end