class PrTreeNode < ActiveRecord::Base
  self.abstract_class = true

  attr_accessor :root_node
  attr_accessor :head_node
  attr_accessor :main_page
  attr_accessor :link
  attr_accessor :parent
  attr_accessor :embedded_pages
  attr_accessor :tree

  @@id = 0

  def initialize(tree)
    @root_node = false
    @head_node = false
    @@id += 1
    @id = @@id
    @parent = nil
    @children = []
    @main_page = nil
    @embedded_pages = []
    @tree = tree
  end

  def to_s
    'PrTreeNode'
  end

  def self.to_s
    'PrTreeNode class'
  end

  def self.build(tree, link, parent_node)
    n = new(tree)
    n.main_page = link.az_page
    n.parent = parent_node
    if parent_node.main_page
      n.head_node = parent_node.main_page.root
    end
    n.embedded_pages = link.az_page.get_embedded_pages1
    n.link = link
    return n
  end

  def self.build_root(tree, link, root_page)
    #parent_node = nil
    #link = nil
    
    n = new(tree)
    n.main_page = root_page
    if link && link.az_parent_page
      n.head_node = link.az_parent_page.root
    end
    n.parent = nil
    n.embedded_pages = root_page.get_embedded_pages1
    n.link = link
    n.root_node = true
    return n
  end

  def add_child(node)
    @children << node
    @children.sort!{|a, b| a.get_link.position <=> b.get_link.position}
  end

  def get_children
    return @children
  end

  def get_embedded_pages
    return @embedded_pages
  end

  def get_parent
    return @parent
  end

  def get_link
    return @link
  end

  #def get_id
  #  return @id
  #end

  def get_child_link_ids
    return @children.collect{|c| c.get_link.id}
  end

  def get_path_string(path_str = '')
    if root_node
      if main_page.root
        #return tree.path_prefix + 'root-' + main_page.id.to_s
        return 'root-' + main_page.id.to_s
      else
        #return tree.path_prefix + main_page.id.to_s
        return main_page.id.to_s
      end
      
    else
      path_str = parent.get_path_string(path_str) + '-' + main_page.id.to_s
    end
    return path_str
  end

  def get_parent_path_string
    if parent
      return parent.get_path_string
    else
      #return tree.path_prefix
      return ''
    end
  end

end
