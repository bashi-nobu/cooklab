require 'rails_helper'
describe User, type: :model do
  describe '#create' do
    context "can save" do
      #全項目に条件を満たす入力があれば保存できる
      it "is valid with a name, email, password, password_confirmation" do
        user = build(:user)
        expect(user).to be_valid
      end
    end
    context "can't save" do
      # メールアドレスが未入力だと保存できない
      it "is invalid without name" do
        user = build(:user, name: nil)
        user.valid?
        expect(user.errors[:name]).to include("が入力されていません。")
      end
      # メールアドレスが未入力だと保存できない
      it "is invalid without email" do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include("が入力されていません。")
      end
      # 登録済みのメールアドレスだと保存できない
      it "is invalid with a duplicate email address" do
        #はじめにユーザーを登録
        user = create(:user)
        #先に登録したユーザーと同じemailの値を持つユーザーのインスタンスを作成
        another_user = build(:user)
        another_user.valid?
        expect(another_user.errors[:email]).to include("は既に使用されています。")
      end
      # パスワードが未入力だと保存できない
      it "is invalid without password" do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include("が入力されていません。")
      end
      # パスワードとパスワード(確認用)が一致しないと保存できない
      it "is not match password and password_confirmation" do
        user = build(:user, password_confirmation: "gggghhhj")
        user.valid?
        expect(user.errors[:password_confirmation]).to include("が一致しません。")
      end
      # パスワードが6文字未満だと保存できない
      it "is password length less than 6" do
        user = build(:user, password: "ddf")
        user.valid?
        expect(user.errors[:password]).to include("は6文字以上に設定して下さい。")
      end
      # 生年月日が無効な日付だと保存できない
      it "is invalid without names" do
        expect { build(:user2) }.to raise_error(described_class::ArgumentError)
      end
    end
  end
end

# 未記入ならばエラー
# ・メールアドレス
# ・パスワード
# ・パスワード(確認用)
# ・ユーザーネーム
# ・メールアドレス&パスワード
# ・パスワード&パスワード(確認用)
# ・メールアドレス&パスワード(確認用)
# ・メールアドレス&パスワード&パスワード(確認用)
# ・メールアドレス&パスワード&ユーザーネーム
# ・パスワード&パスワード(確認用)&ユーザーネーム
# ・メールアドレス&パスワード(確認用)&ユーザーネーム
# ・メールアドレス&パスワード&パスワード(確認用)&ユーザーネーム
# ・メールアドレス&ユーザーネーム
# ・パスワード&ユーザーネーム
# ・パスワード(確認用)&ユーザーネーム
# 全記入でかつパスワードが6文字以上でアドレスがメールアドレス形式ならばOK
# ・メールアドレス&パスワード&パスワード(確認用)&ユーザーネーム
# 全記入だがパスワードが6文字未満ならばエラー
# 全記入だがアドレスがメールアドレス形式でないならばエラー
# 全記入だがパスワードが6文字未満でかつアドレスがメールアドレス形式でないならばエラー
# プロフィールの生年月日欄に無効な日付(2月30日)を入力してもエラー