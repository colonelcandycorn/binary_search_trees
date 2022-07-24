class Tree
  require_relative './node'

  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  def build_tree(array, start = 0, finish = array.length - 1)
    return nil if start > finish

    root = Node.new(array[(start + finish) / 2])
    root.left = build_tree(array, start, (start + finish) / 2 - 1)
    root.right = build_tree(array, (start + finish) / 2 + 1, finish)

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

testarray = Array.new(20) { rand(1..20) }
tree = Tree.new(testarray)
tree.pretty_print