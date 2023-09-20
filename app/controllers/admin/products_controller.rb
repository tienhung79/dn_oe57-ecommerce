class Admin::ProductsController < ApplicationController
  before_action :load_info_categories, only: %i(show index new create edit update)
  before_action :load_product, only: %i(show edit update )
  before_action :admin_user, only: %i(new create edit update destroy)

  def index
    @pagy, @products = pagy(Product.newest, items: Settings.orders.number_of_page_5)
  end

  def show
    @feedbacks = @product.feedbacks.newest
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    category = Category.find_by id: params[:product][:category_id]
    @product = category.products.build product_params
    if @product.save
      flash[:success] = "OK"
      redirect_to admin_products_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update product_params
      flash[:success] = t("product_updated")
      redirect_to admin_products_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find_by id: params[:id]
    if @product.destroy
      flash[:success] = t("user_deleted")
    else
      flash[:danger] = t("delete_fail")
    end
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :price,
                                    :description, :quantity, :rating, :image)
  end

  def search_by_name
    search_results = Product.search_by_name(params[:name])
    @pagy, @products = pagy(search_results,
                            items: Settings.products.number_of_page_10)
  end

  def search_by_category
    @children_categories = Category.find_id_or_parent(params[:id])
    children_category_id = @children_categories.pluck(:id)
    search_results = if @children_categories.length == 1
                       Product.filter_by_category_id(params[:id])
                     else
                       Product.filter_by_category_id(children_category_id)
                     end
    @pagy, @products = pagy(search_results,
                            items: Settings.products.number_of_page_10)
  end

  def default_search
    search_results = Product.all
    @pagy, @products = pagy(search_results,
                            items: Settings.products.number_of_page_10)
  end

  def handle_empty_search search_results
    flash.now[:notice] = "Không tìm thấy sản phẩm nào." if search_results.empty?
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    flash[:danger] = t("product_not_found")
    redirect_to root_url
  end

  def admin_user
    if current_user&.is_admin?
    else
      redirect_to root_path
      flash[:alert] = t("not_permission")
    end
  end
end
