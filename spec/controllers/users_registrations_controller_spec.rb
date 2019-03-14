require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe 'アカウント登録画面への遷移できる' do
    it "renders the :new template" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new, params: { account_patarn: "mail" }
      expect(response).to render_template :new
    end
    it "renders the :new template" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new, params: { account_patarn: "fb" }
      expect(response).to render_template :new
    end
    it "renders the :new template" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new, params: { account_patarn: "tw" }
      expect(response).to render_template :new
    end
  end
  describe '未ログインユーザーが編集画面へアクセスした場合はログイン画面へ遷移)' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    it "renders the login template" do
      get :edit, params: { account_patarn: "mail" }
      expect(response.status).to eq(302)
    end
    it "renders the login template" do
      get :edit, params: { account_patarn: "fb" }
      expect(response.status).to eq(302)
    end
    it "renders the login template" do
      get :edit, params: { account_patarn: "tw" }
      expect(response.status).to eq(302)
    end
  end
  describe 'ログイン済みユーザーがユーザー情報編集画面へアクセスできる' do
    let(:user) { create(:user) }
    before do
      login_user user
    end
    it "renders the :edit template" do
      get :edit, params: { account_patarn: "mail" }
      expect(response).to render_template :edit
    end
  end
  describe 'ユーザー情報の更新処理' do
    context 'can update' do
      let(:user) { create(:user) }
      let(:user_name_update_params) do
        {
          name: 'new_name!',
          password: '',
          password_confirmation: '',
          email: user.email,
        }
      end
      let(:user_password_update_params) do
        {
          name: user.name,
          password: 'newpassword',
          password_confirmation: 'newpassword',
          email: user.email
        }
      end
      before do
        login_user user
      end
      it 'パスワード入力なしでも更新できる。更新登録したユーザー名を取得できる' do
        patch :update, params: { user: user_name_update_params }
        expect(user.reload.name).to eq 'new_name!'
      end
      it 'パスワード入力ありでも更新できる。更新登録したパスワードを取得できる' do
        patch :update, params: { user: user_password_update_params }
        expect(user.reload.valid_password?('newpassword')).to eq(true)
      end
    end
  end
  describe 'アカウント退会画面への遷移できる' do
    let(:user) { create(:user) }
    before do
      login_user user
    end
    it "deletes the user" do
      get :delete
      expect(response).to render_template :delete
    end
  end
  describe '#退会処理が行われるとユーザーが削除される' do
    let(:user) { create(:user) }
    before do
      login_user user
    end
    it "destroy the user" do
      expect do
        delete :destroy
      end.to change(User, :count).by(-1)
    end
  end
  # let(:group) { create(:group) }
  # let(:user) { create(:user) }

  # describe '#index' do

  #   context 'log in' do
  #     before do
  #       login user
  #       get :index, params: { group_id: group.id }
  #     end

  #     it 'assigns @message' do
  #       expect(assigns(:message)).to be_a_new(Message)
  #     end

  #     it 'assigns @group' do
  #       expect(assigns(:group)).to eq group
  #     end

  #     it 'redners index' do
  #       expect(response).to render_template :index
  #     end
  #   end

  #   context 'not log in' do
  #     before do
  #       get :index, params: { group_id: group.id }
  #     end

  #     it 'redirects to new_user_session_path' do
  #       expect(response).to redirect_to(new_user_session_path)
  #     end
  #   end
  # end

  # describe '#create' do
  #   let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }

  #   context 'log in' do
  #     before do
  #       login user
  #     end

  #     context 'can save' do
  #       subject {
  #         post :create,
  #         params: params
  #       }

  #       it 'count up message' do
  #         expect{ subject }.to change(Message, :count).by(1)
  #       end

  #       it 'redirects to group_messages_path' do
  #         subject
  #         expect(response).to redirect_to(group_messages_path(group))
  #       end
  #     end

  #     context 'can not save' do
  #       let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }

  #       subject {
  #         post :create,
  #         params: invalid_params
  #       }

  #       it 'does not count up' do
  #         expect{ subject }.not_to change(Message, :count)
  #       end

  #       it 'renders index' do
  #         subject
  #         expect(response).to render_template :index
  #       end
  #     end
  #   end

  #   context 'not log in' do

  #     it 'redirects to new_user_session_path' do
  #       post :create, params: params
  #       expect(response).to redirect_to(new_user_session_path)
  #     end
  #   end
  # end
end
