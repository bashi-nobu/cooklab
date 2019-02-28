require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe 'GET #new' do
    # アカウント登録画面への遷移(メールアドレス)
    it "renders the :new template" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new, params: { account_patarn: "mail" }
      expect(response).to render_template :new
    end
    # アカウント登録画面への遷移(facebook)
    it "renders the :new template" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new, params: { account_patarn: "fb" }
      expect(response).to render_template :new
    end
    # アカウント登録画面への遷移(twitter)
    it "renders the :new template" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new, params: { account_patarn: "tw" }
      expect(response).to render_template :new
    end
  end
  describe 'GET #edit(not login)' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    # 編集画面へアクセスした場合はログイン画面へ遷移(メールアドレス)
    it "renders the :new template" do
      get :edit, params: { account_patarn: "mail" }
      expect(response.status).to eq(302)
    end
    it "renders the :new template" do
      get :edit, params: { account_patarn: "fb" }
      expect(response.status).to eq(302)
    end
    it "renders the :new template" do
      get :edit, params: { account_patarn: "tw" }
      expect(response.status).to eq(302)
    end
  end
  describe 'GET #edit(login)' do
    # ログイン済みユーザーがユーザー情報編集画面へアクセスできる
    let(:user) { create(:user) }
    before do
      login_user user
    end
    it "renders the :edit template" do
      get :edit, params: { account_patarn: "mail" }
      expect(response).to render_template :edit
    end
  end
  describe 'PATCH #update' do
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
      it 'update user.name without current password' do
        patch :update, params: { user: user_name_update_params }
        expect(user.reload.name).to eq 'new_name!'
        # expect(response).to redirect_to admin_admin_users_path
      end
      it 'update user.password' do
        patch :update, params: { user: user_password_update_params }
        expect(user.reload.valid_password?('newpassword')).to eq(true)
        # expect(response).to redirect_to admin_admin_users_path
      end
    end
  end
  describe 'GET #delete' do
    #退会ページへアクセス
    let(:user) { create(:user) }
    before do
      login_user user
    end
    it "deletes the user" do
      get :delete
      expect(response).to render_template :delete
    end
  end
  describe 'DELETE #destroy' do
    #退会処理が行われるとユーザーが削除される
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
