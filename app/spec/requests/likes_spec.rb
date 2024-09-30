require 'rails_helper'

RSpec.describe "Likes", type: :request do
  describe "POST /create" do
    let(:liked_post) { create(:post) }

    subject(:request) { post post_likes_path(liked_post), params: {} }

    context 'いいねしていない投稿の場合' do
      include_examples :sign_in
      it '指定した投稿をいいねすること' do
        expect { request }.to change { current_user.liked?(liked_post) }.from(false).to(true)
      end
    end
    context 'いいねしている投稿の場合' do
      include_examples :sign_in
      before { create(:like, user: current_user, post: liked_post) }

      it '指定した投稿をいいねしないこと' do
        expect { request }.not_to change { current_user.liked?(liked_post) }
      end
    end
  end
end
