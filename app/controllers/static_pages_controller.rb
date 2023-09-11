class StaticPagesController < ApplicationController
  include CategoriesHelper

  def home
    @pagy, @products = pagy(Product.all, items: 5)
    get_category
  end
end
