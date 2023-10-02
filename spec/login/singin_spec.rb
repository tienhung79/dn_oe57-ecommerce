require 'rails_helper'



RSpec.describe SessionController, type: :controller do
  let!(:user) { create(:user) }

  describe "POST #create" do
    context "with valid credentials" do
      before do
        post :create, params: { session: { email: user.email, password: user.password } }
      end

      it_behaves_like "successful login"
    end

    context "with invalid credentials" do
      before do
        post :create, params: { session: { email: 'invalid@example.com', password: 'wrongpassword' } }
      end
      
      it_behaves_like "fail login"
    end
  end
end
