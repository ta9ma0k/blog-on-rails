require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /index" do
    before { create_list(:post, 3) }

    context '認証していない場合' do
      it '投稿された順に投稿が表示されること' do
        get root_path
        expect(response).to have_http_status(:success)
        posts = controller.instance_variable_get('@posts')
        expect(posts).to eq Post.recently
      end
    end

    context '認証している場合' do
      include_examples :sign_in

      before do
        followee = create(:user)
        create(:follow, user: current_user, followee:)
        create_list(:post, 3, user: followee)

        create(:post)
      end

      context 'filterが指定されない場合' do
        it '投稿された順に投稿が表示されること' do
          get root_path
          expect(response).to have_http_status(:success)
          posts = controller.instance_variable_get('@posts')
          expect(posts).to eq Post.recently
        end
      end
      context 'filter=followが指定された場合' do
        it 'フォローしているユーザの投稿のみ表示されること' do
          get root_path(filter: 'follow')
          expect(response).to have_http_status(:success)
          posts = controller.instance_variable_get('@posts')
          expect(posts).to eq current_user.followee_posts.recently
        end
      end
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
    context 'サムネイル画像を含むリクエストした場合' do
      include_examples :sign_in
      let(:params) {
        {
          post: {
            body: 'hi',
            thumbnail: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), 'image/png')
          }
        }
      }
      it 'サムネイル画像付きで投稿が作成されること' do
        expect { request }.to change { current_user.posts.count }.by(1)
        post = current_user.posts.last
        expect(post.thumbnail).to be_attached
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
