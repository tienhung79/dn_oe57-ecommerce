class ProductsController < ApplicationController
  include CategoriesHelper

  def new
    @product = Product.new
  end

  def create
    category = Category.find_by id: params[:product][:category_id]
    @product = category.products.build product_params
    return unless @product.save

    flash[:success] = "OK"
    redirect_to root_url
  end

  def product_params
    params.require(:product).permit(:name, :price,
                                    :description, :quantity, :rating,:image)
  end

  def index
    if params[:name].present?
      @pagy, @products = pagy(
        Product.where("name LIKE ?", "%#{params[:name]}%"), items: 2
      )
      get_category
      render "static_pages/home"
    elsif params[:format].present?
      @category = Category.find_by name: params[:format]
      @children_category = Category.where("parent_id = ? OR id = ?",
                                          @category.id, @category.id)
      if @children_category.length == 1
        @pagy, @products = pagy(Product.where(category_id: @category.id),
                                items: 2)
        get_category
      else
        @pagy, @products = pagy(
          Product.where(category_id: @children_category.pluck(:id)), items: 2
        )
        get_category
      end
      render "static_pages/home"
    else
      @pagy, @products = pagy(Product.all, items: 2)
      get_category
      flash[:fail] = "Không tìm thấy sản phẩm"
      render "static_pages/home"
    end
  end
end
