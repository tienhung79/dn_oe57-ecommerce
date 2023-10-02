RSpec.shared_examples "successful login" do
  it "redirects to root_path" do
    expect(response).to redirect_to(root_path)
  end
end

RSpec.shared_examples "fail login" do
    it "renders the new template" do
      expect(response).to render_template(:new)
    end

    it "sets flash message" do
      expect(flash[:danger]).to eq(I18n.t("invalid_email_password_combination"))
    end
end

RSpec.shared_examples "request login for function" do
    it "renders the new template" do
      expect(response).to redirect_to(login_url)
    end

    it "sets flash message" do
      expect(flash[:danger]).to eq(I18n.t("please_log_in"))
    end
end
