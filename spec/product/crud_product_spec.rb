require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  let!(:admin) {create :user, email: "admin@gmal.com", is_admin: true}
  let!(:user) {create :user, email: "user@gmal.com", is_admin: false}
  let(:category) {create :category, name: "Category"}
  let!(:product) {create :product, category_id: category.id}
  let(:valid_params) { { product: { name: 'San pham', price: 100000, description: ' mo ta', quantity: 12, rating: 0, category_id: category.id } } }
  let(:invalid_params) { { product: { name: '', price: 0, description: '', quantity: 1200, rating: 0, category_id: category.id } } }
  let(:valid_params_update) { { id: product.id, product: { name: 'San pham', description: 'mo ta' } } }
  let(:invalid_params_update) { { id: product.id, product: { name: '', description: '' } } }

  describe "GET#index" do
    context "into index success" do
      before do
        session[:user_id] = admin.id
        get :index
      end

      it "assigns @products" do
        expect(assigns(:products)).to include(product)
      end

      it "render the index template" do
        expect(response).to render_template("index")
      end
    end

    context "into index fail " do
      before do
        session[:user_id] = user.id
        get :index
      end

      it "message user not admin" do
        expect(flash[:alert]).to eq(I18n.t("not_permission"))
      end

      it "redirect to root" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "CREATE#product" do
    context "create product success" do
      before do
        session[:user_id] = admin.id
      end

      it "render template new" do
        get :new
        expect(response).to render_template("new")
      end

      context "create when render template new success" do
        before do
          post :create, params: valid_params
        end

        it 'check data in database' do
          expect {post :create, params: valid_params}.to change(Product, :count).by(1)
        end

        it 'redirects to the products index page' do
          expect(response).to redirect_to(admin_products_path)
        end

        it "message create success" do
          expect(flash[:success]).to eq(I18n.t('success'))
        end
      end

    end

    context "create product fail" do

      context "user not is admin" do
        before do
          session[:user_id] = user.id
          post :create, params: valid_params
        end

        it "message user not admin" do
          expect(flash[:alert]).to eq(I18n.t("not_permission"))
        end

        it "redirect to root" do
          expect(response).to redirect_to(root_path)
        end
      end

      context "data invalid and user is admin" do
        before do
          session[:user_id] = admin.id
          post :create, params: invalid_params
        end

        it "data in database not change" do
          expect {post :create, params: invalid_params}.to_not change(Product, :count)
        end

        it 'renders the new template' do
          expect(response).to render_template(:new)
        end

        it 'unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "UPDATE#products" do
    context "update product success" do
      before do
        session[:user_id] = admin.id
      end

      context "render template and product to update" do
        let(:params_into_update) {{id: product.id}}

        before do
          get :edit, params: params_into_update
        end
        it "render template update" do
          expect(response).to render_template("edit")
        end

        it "get product to update" do
          expect(assigns(:products)) == ([product])
        end
      end

      context "update infomation of product success" do

        before do
          patch :update, params: valid_params_update
          product.reload
        end

        it "infomation of product has been updated" do
          expect(product.name).to eq('San pham')
          expect(product.description).to eq('mo ta')
        end

        it "redirects to the products index page" do
          expect(response).to redirect_to(admin_products_path)
        end

        it "sets a success flash message" do
          expect(flash[:success]).to eq(I18n.t('product_updated'))
        end

      end
    end

    context "update product fails" do
      context "user is not admin" do
        before do
          session[:user_id] = user.id
          patch :update, params: valid_params_update
        end

        it "message user not admin" do
          expect(flash[:alert]).to eq(I18n.t("not_permission"))
        end

        it "redirect to root" do
          expect(response).to redirect_to(root_path)
        end
      end

      context "user is admin but date fail " do
        before do
          session[:user_id] = admin.id
          patch :update, params: invalid_params_update
        end

        it 'does not update the product' do
          expect(product.name).to_not be_blank
          expect(product.description).to_not be_blank
        end

        it 'renders the edit template' do
          expect(response).to render_template(:edit)
        end

        it 'unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
