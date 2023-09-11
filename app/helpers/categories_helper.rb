module CategoriesHelper
  def get_category
    @parent_items = Category.find_by parent_id: nil
    @children = @parent_items.children
    @children_children = Category.where(parent_id: @children.pluck(:id))
  end
end
