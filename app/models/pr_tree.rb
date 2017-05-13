class PrTree < ActiveRecord::Base
  self.abstract_class = true

  attr_accessor :root
  #attr_accessor :path_prefix

  def initialize(project, link = nil)
    if link
      root_page = link.az_page
    else
      root_page = project.get_root_page
    end
    #@path_prefix = ''
    @root = PrTreeNode.build_root(self, link, root_page)
  end

  def self.build(project)
    return PrTree.build_sub_tree(project)
  end

  def self.build_sub_tree(project, link = nil, max_level = 20)
    tree = PrTree.new(project, link)
    if tree.root.main_page.root
      roots_links = tree.root.main_page.child_links#.select{|l| !l.az_page.embedded }
    else
      page = tree.root.main_page
      not_embedded = page.get_not_embedded_links
      embedded  = page.get_embedded_links
      children_embedded = []
      embedded.each do |e|
        children_embedded.concat(e.az_page.get_not_embedded_links)
      end
      roots_links = not_embedded.concat(children_embedded)
    end
    
    tree.build_tree_internal(tree.root, roots_links, 1, max_level)
    return tree
  end

  def walk_public_admin_subtree(page_type, &b)
    walked_page_ids = {}

    walk(nil, page_type) do |node|
      if !node.main_page.root && !walked_page_ids[node.main_page.id]
        b.call(node)
        walked_page_ids[node.main_page.id] = node.main_page.id
      end
    end
  end

  def walk_public_subtree(&b)
    walk_public_admin_subtree(AzPage::Page_user, &b)
  end

  def walk_admin_subtree(&b)
    walk_public_admin_subtree(AzPage::Page_admin, &b)
  end

  def walk(from_node = nil, page_type = nil, max_level = 20, current_level = 0, &b)
    
    if from_node == nil
      node = @root
    else
      node = from_node
    end
    #puts "#{node.main_page.name} #{node.main_page.page_type?(page_type)}"
    # Тип страницы учитываем только для первого уровня дерева, т.е. сразу за root-ом
    if (current_level > 1)
      page_type = nil
    end
    if node && (current_level < max_level) && (node.main_page.page_type?(page_type) || node.main_page.root)
      
      b.call(node)
      node.get_children.each do |n|
        walk(n, page_type, max_level, current_level + 1, &b)
      end
    end
  end

  def build_tree_internal(node, child_links, level, max_level)
    if level >= max_level
      return
    end
    child_links.each do |link|
      page = link.az_page
      n = PrTreeNode.build(self, link, node)
      node.add_child(n)

      not_embedded = page.get_not_embedded_links
      embedded  = page.get_embedded_links
      children_embedded = []
      embedded.each do |e|
        children_embedded.concat(e.az_page.get_not_embedded_links)
      end

      build_tree_internal(n, not_embedded.concat(children_embedded), level + 1, max_level)
    end
  end

  def self.generate_gv(project)
    ptree = PrTree.build(project)
    lines = ['digraph G {', 'node [shape=box];', 'graph [rankdir="LR"];']
    ptree.walk(){|n| lines << "\"#{n.get_parent.main_page.name}-#{n.get_parent.main_page.id}\" -> \"#{n.main_page.name}-#{n.main_page.id}\";" unless n.get_parent.nil? }
    lines << '}'
    puts lines.join("\n")
  end

  def self.generate_gv1(project)
    ptree = PrTree.build(project)
    lines = ['digraph G {', 'node [shape=box];', 'graph [rankdir="LR"];']
    nodes = []
    links = []

    ptree.walk(){|n| links << "#{n.get_parent.main_page.id} -> #{n.main_page.id};" unless n.get_parent.nil?; nodes << n }
    links.uniq!
    lines.concat(links)
    nodes.each do |n|
      lines << "#{n.main_page.id} [label=\"#{n.main_page.name}\"];"
    end
    lines << '}'
    puts lines.join("\n")
  end

  private
  
end
