class CartController < ApplicationController
  before_action :logged_in_user, :load_product, only: :add_to_cart

  def add_to_cart
    session[:cart] ||= {}
    session[:cart][@product.id.to_s] ||= 0
    session[:cart][@product.id.to_s] += 1
    respond_to do |format|
      format.html{redirect_to @product}
      format.js
    end
  end

  def index
    @cart = session[:cart] || {}
    @products = Product.find_id(@cart.keys)
  end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t("product_not_found")
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("please_log_in")
    store_location
    redirect_to login_url
  end
end
