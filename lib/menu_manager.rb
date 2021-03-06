require 'rubygems'
require 'mongoid'
require 'mongoid/tree'

class MenuManager
  def get_node node_id
    return Tree.find(node_id)
  end
  
  def get_root
    node_id = Tree.root.id.to_s    
    return self.get_particular_menu node_id
  end  

  def is_root node_id
    node = self.get_node node_id
    return node.root? unless node.nil?
    return false
  end

  def get_advs parent_node
    advs = Adv.find(:conditions => { :node_id => parent_node.id.to_s }).desc("ctime")
    return advs
  end

  def get_one_adv node_id, position, limit
    advs = Adv.where(:node_id => node_id).desc("ctime").skip(position).limit(limit)
    return advs
  end

  def get_prev_menu node_id
    node = self.get_node node_id
    return self.get_particular_menu node.parent.id.to_s
  end
  
  def get_menu_by_item_number node, item_number
    if node.leaf?
      menu_item = MenuItem.new
      menu_item.node = node
      menu_item.is_leaf = true
      return menu_item
    end
    node_id = node.children[item_number-1].id.to_s  
    return self.get_particular_menu node_id
  end
  
  def get_particular_menu node_id 
    menu_item = MenuItem.new
    node = Tree.root
    node.traverse(:breadth_first) do |n|
      if self.node_exists n, node_id
        i = 0
        n.children.each do |child|
          i += 1
          menu_item.menu_items << child
          menu_item.menu_text_items << i.to_s + "-" + child.name
        end
        menu_item.node = n
        return menu_item
      end
    end
  end

  def node_exists n, node_id
    return n.id.to_s == node_id
  end

  def get_adv node_id

  end

  def get_price_range node

  end

  def get_city_list node

  end
end

class MenuItem
  attr_accessor :node, :menu_text_items, :is_leaf, :menu_items

  def initialize
    @menu_items = Array.new
    @menu_text_items = Array.new
    @is_leaf = false
  end
end
