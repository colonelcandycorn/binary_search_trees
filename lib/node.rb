class Node
  include Comparable
  attr_accessor :left, :right, :data

  def <=>(other)
    @value <=> other.value
  end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end
