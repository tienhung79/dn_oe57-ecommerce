class OrdersController < ApplicationController
  include CartHelper

  before_action :logged_in_user
  before_action :load_product_in_cart, :total_price, only: :create
  before_action :load_order, only: :show

  def index
    @orders = current_user.orders.includes(:order_details)
  end

  def show; end

  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build order_params
      @order.save!
      create_order_detail @order
      update_quantity_products
      session[:cart].clear
      flash[:success] = t("success")
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = t("error")
    render "cart/index", status: :unprocessable_entity
  end

  private
  def order_params
    params.require(:order).permit :reciver_name,
                                  :reciver_address,
                                  :reciver_phone,
                                  :total_price, :status
  end

  def load_order
    @order = Order.includes(:order_details).find_by id: params[:id]
    return if @order

    flash[:danger] = t("order_not_found")
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("please_log_in")
    store_location
    redirect_to login_url
  end

  def create_order_detail order
    keys_session = session[:cart]&.keys&.map(&:to_i)
    @products = Product.find_id keys_session
    order_details = []
    @products.each do |product|
      order_detail = OrderDetail.new(
        product:,
        order:,
        price_product: product.price,
        quantity_product: session[:cart][product.id.to_s]
      )
      order_details << order_detail
    end
    order_details.each(&:save!)
  end

  def update_quantity_products
    keys_session = session[:cart]&.keys&.map(&:to_i)
    @products = Product.find_id keys_session
    @products.each do |product|
      product.quantity = product.quantity - session[:cart][product.id.to_s]
    end
    @products.each(&:save!)
  end
end
