module CartHelper
  def load_product_in_cart
    @order = Order.new
    @cart = session[:cart] || {}
    @products = Product.find_id(@cart.keys)
  end

  def total_price
    @total_price = 0
    @cart = session[:cart] || {}
    @cart.each do |key, value|
      product = Product.find_by id: key
      if product
        @total_price += product.price * value
      else
        session[:cart].delete(key)
      end
    end
  end
end
