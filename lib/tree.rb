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

  def insert(data, root = @root)
    return Node.new(data) if root.nil?

    if data > root.data
      root.right = insert(data, root.right)
    else
      root.left = insert(data, root.left)
    end

    root
  end

  def delete(data, node = @root)
    return node if node.nil?

    if data > node.data
      node.right = delete(data, node.right)

    elsif data < node.data
      node.left = delete(data, node.left)

    else

      if node.left.nil?
        return node.right
      elsif node.right.nil?
        return node.left
      else
        temp = min_value(node.right)
        node.data = temp.data
        node.right = delete(temp.data, node.right)
      end
    end
    node
  end

  def min_value(node)
    current_node = node
    while current_node.left
      current_node = current_node.left
    end
    current_node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

testarray = [1,2,3,4,5,6,7,8,9]
tree = Tree.new(testarray)
tree.pretty_print
tree.insert(0)
tree.pretty_print
tree.delete(5)
tree.pretty_print