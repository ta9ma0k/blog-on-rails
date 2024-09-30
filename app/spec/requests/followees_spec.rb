require 'rails_helper'

RSpec.describe "Followees", type: :request do
  describe "POST /create" do
    let(:followed_user) { create(:user) }

    subject(:request) { post followees_path, params: }

    context 'フォローしていないユーザの場合' do
      include_examples :sign_in
      let(:params) { { username: followed_user.name } }
      it '指定したユーザをフォローすること' do
        expect { request }.to change { current_user.follow?(followed_user) }.from(false).to(true)
      end
    end
    context 'フォローしているユーザの場合' do
      include_examples :sign_in
      let(:params) { { username: followed_user.name } }
      before { create(:follow, user: current_user, followee: followed_user) }
      it 'フォローに変化がないこと' do
        expect { request }.not_to change { current_user.follows.count }
      end
    end
    context '存在していないユーザ名をPOSTした場合' do
      include_examples :sign_in
      let(:params) { { username: "nouser" } }
      it 'フォローに変化がないこと' do
        expect { request }.not_to change { current_user.follows.count }
      end
    end
    context '未認証状態の場合' do
      let(:params) { { username: followed_user.name } }
      it 'フォローに変化がないこと' do
        expect { request }.not_to change(Follow, :count)
      end
    end
  end
end
