require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /index" do
    before { create_list(:post, 3) }

    it '投稿された順に投稿が表示されること' do
      get root_path
      expect(response).to have_http_status(:success)
      posts = controller.instance_variable_get('@posts')
      expect(posts).to eq Post.recently
    end
  end

  describe "POST /create" do
    subject(:request) { post posts_path, params: }

    context 'bodyが140字以内でリクエストした場合' do
      include_examples :sign_in
      let(:params) { { post: { body: 'hi' } } }
      it '投稿が作成されること' do
        expect { request }.to change { current_user.posts.count }.by(1)
      end
    end
    context 'bodyが140字を超える場合' do
      include_examples :sign_in
      let(:params) { { post: { body: '*' * 141 } } }
      it '投稿が作成されないこと' do
        expect { request }.not_to change(Post, :count)
      end
    end
    context 'bodyが0字を超える場合' do
      include_examples :sign_in
      let(:params) { { post: { body: '' } } }
      it '投稿が作成されないこと' do
        expect { request }.not_to change(Post, :count)
      end
    end
    context 'bodyがリクエストボディにない場合' do
      include_examples :sign_in
      let(:params) { { post: {} } }
      it '投稿が作成されないこと' do
        expect { request }.not_to change(Post, :count)
      end
    end
    context '未認証状態の場合' do
      let(:params) { { post: { body: 'hi' } } }
      it '投稿が作成されないこと' do
        expect { request }.not_to change(Post, :count)
      end
    end
  end
end
