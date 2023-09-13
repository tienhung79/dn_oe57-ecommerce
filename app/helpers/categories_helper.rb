module CategoriesHelper
  def load_info_categories
    @parent_items = Category.parent_items
    @childrens = Category.children_of(@parent_items)
    @children_childrens = Category.children_of(@childrens)
  end
end
