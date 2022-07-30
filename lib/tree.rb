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
      array.push(queue.shift)
    end
    block_given? ? array.each { |node| yield node }: array
  end

  def level_order_recursion(node = @root, level = 0)
    array = [[node, level]]
    array += level_order_recursion(node.left, level + 1) if node.left
    array += level_order_recursion(node.right, level + 1) if node.right
    array.sort { |one, two| one[1] <=> two[1] } if level.zero?
    block_given? ? array.map { |queue| yield queue[0] } : array
  end

  def inorder(node = @root, stack = [])
    stack = inorder(node.left, stack) if node.left
    stack.push(node.data)
    stack = inorder(node.right, stack) if node.right
    block_given? ? (stack.each {|data| yield data }) : stack
  end

  def preorder(node = @root, queue = [])
    queue.push(node.data)
    queue = preorder(node.left, queue) if node.left
    queue = preorder(node.right, queue) if node.right
    block_given? ? (queue.each {|data| yield data }) : queue
  end

  def postorder(node = @root, array = [])
    array = postorder(node.left, array) if node.left
    array = postorder(node.right, array) if node.right
    array.push(node.data)
    block_given? ? (array.each {|data| yield data }) : array
  end

  def height(node, count = 0)
    return count if node.left.nil? && node.right.nil?

    return height(node.left, count + 1) if node.right.nil?

    return height(node.right, count + 1) if node.left.nil?

    [height(node.left, count + 1), height(node.right, count + 1)].max
  end

  def depth(node, count = 0, current_node = @root)
    return count if current_node == node

    return 0 if current_node.left.nil? && current_node.right.nil?

    return depth(node, count + 1, current_node.left) if current_node.right.nil?

    return depth(node, count + 1, current_node.right) if current_node.left.nil?

    [depth(node, count + 1, current_node.left), depth(node, count + 1, current_node.right)].max
  end

  def balanced?(node = @root)
    if node.left && node.right
      return false if (height(node.right) - height(node.left)).abs > 1

      result = balanced?(node.right) && balanced?(node.left)
    elsif node.right
      result = height(node.right).zero?
    elsif node.left
      result = height(node.left).zero?
    else
      result = true
    end
    result
  end

  def rebalance
    @root = build_tree(inorder)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
