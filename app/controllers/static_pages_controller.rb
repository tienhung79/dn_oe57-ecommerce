class StaticPagesController < ApplicationController
  include CategoriesHelper

  before_action :load_info_categories, only: :home

  def home
    @pagy, @products = pagy Product.sort_by_name,
                            items: Settings.products.number_of_page_10
  end
end
