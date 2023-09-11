class StaticPagesController < ApplicationController
  def home
    @pagy, @products = pagy Product.sort_by_name, items: Settings.products.number_of_page_10
    @categories = Category.child_categories
  end
end
