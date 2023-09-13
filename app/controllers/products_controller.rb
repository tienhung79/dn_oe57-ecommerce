class ProductsController < ApplicationController
  include CategoriesHelper

  before_action :load_info_categories, :load_product, only: :show

  def show; end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t("product_not_found")
    redirect_to root_url
  end
end
