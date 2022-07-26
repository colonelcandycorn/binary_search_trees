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

  def find(data, node = @root)
    return find(data, node.right) if data > node.data

    return find(data, node.left) if data < node.data

    return node if data == node.data
  end

  def min_value(node)
    current_node = node
    while current_node.left
      current_node = current_node.left
    end
    current_node
  end

  def level_order(node = @root)
    queue = []
    array = []
    queue.push(node)
    until queue.empty?
      current_node = queue[0]
      queue.push(current_node.left) if current_node.left
      queue.push(current_node.right) if current_node.right
      block_given? ? (yield queue.shift) : array.push(queue.shift)
    end
    array
  end

  def level_order_recursion(node = @root, level = 0)
    array = [[node, level]]
    array += level_order_recursion(node.left, level + 1) if node.left
    array += level_order_recursion(node.right, level + 1) if node.right
    array.sort { |one, two| one[1] <=> two[1] } if level.zero?
    block_given? ? array.each { |queue| yield queue[0] } : array
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
p tree.find(3)
tree.level_order { |node| puts "#{node.data}\n" }
array2 = tree.level_order_recursion
array2.each { |array| puts "#{array[0].data}\n" }
string = ''
tree.level_order_recursion { |node| string += node.data.to_s }
puts string