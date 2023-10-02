require 'rails_helper'
require_relative '../../spec/support/share_example'

RSpec.describe OrdersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:order) { create(:order, reciver_name: "User1", reciver_address:" Da nang", reciver_phone: "0123456789", total_price: 10000, status: "awaiting", user_id: user.id) }
  let(:valid_params) { { order: { reciver_name: "User1", reciver_address:" Da nang", reciver_phone: "0123456789", total_price: 10000, status: "awaiting", user_id: user.id } } }
  let!(:invalid_params) { {order: { reciver_name: nil, reciver_address: nil, reciver_phone: nil, total_price: 10000, status: "awaiting", user_id: user.id } } }
  let!(:params_valid) {post :create, params: valid_params}

  describe " CREATE#order " do

    before do
      session[:cart] = { "476" => 1 }
      $product = Product.find_by id: session[:cart].keys
      $quantity_product_in_order = session[:cart]["476"]
    end
    
    context "create success" do
      before do
          session[:user_id] = user.id
          post :create, params: valid_params
      end

      it "clear cart is empty" do
        expect(session[:cart]).to be_empty
      end

      it "display flash success" do
        expect(flash[:success]) == (I18n.t("success"))
      end

      it "redirect root path" do
        expect(response).to redirect_to(root_path)
      end

      it_behaves_like "successful login"

      context "check data in database" do
        it "insert record order table" do
          expect(assigns(:order)) == (order)
        end
        it "insert record order details" do
          order_detail = OrderDetail.first
          expect(order_detail.order_id).to eq(assigns(:order).id)
        end

        it "update quantity product" do
          order_detail = OrderDetail.first
        product_after_order = Product.find_by id: order_detail.product_id
        expect($product.quantity).to eq(product_after_order.quantity + $quantity_product_in_order)
        end
      end
    end

    context "create fail" do

      context "when user not login" do
        before do
          session[:user_id] = nil
          post :create, params: invalid_params
        end

        it_behaves_like "request login for function"
      end

      context "params invalid" do
        before do
          session[:user_id] = user.id
          post :create, params: invalid_params
        end

        context "when data order invalid" do
          it "flash error" do
            expect(flash[:notice]).to eq(I18n.t("error"))
          end

          it "render cart/index" do
            expect(response).to render_template("cart/index")
          end
        end

        context "when data order detail invalid" do

          before do
            allow_any_instance_of(OrderDetail)
              .to receive(:save!)
            .and_raise(ActiveRecord::RecordInvalid)
          end

          it "flash error" do
            expect(flash[:notice]).to eq(I18n.t("error"))
          end

          it "render cart/index" do
            expect(response).to render_template("cart/index")
          end

          it "order table not change record" do
            expect {params_valid}.to_not change(Order, :count)
          end

          it "order detail table not change record" do
            expect {params_valid}.to_not change(OrderDetail, :count)
          end
        end

        context "when data product invalid" do
          before do
            allow_any_instance_of(Product)
              .to receive(:save!)
              .and_raise(ActiveRecord::RecordInvalid)
          end

          it "flash error" do
            expect(flash[:notice]).to eq(I18n.t("error"))
          end

          it "render cart/index" do
            expect(response).to render_template("cart/index")
          end

          it "order table not change record" do
            expect {params_valid}.to_not change(Order, :count)
          end

          it "order detail table not change record" do
            expect {params_valid}.to_not change(OrderDetail, :count)
          end

          it "quantity product not change" do
            product_after_order = Product.find_by id: session[:cart].keys
            expect($product).to eq(product_after_order)
          end
        end
      end
    end
  end
end
