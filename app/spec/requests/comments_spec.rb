require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe "POST /create" do
    let(:commented_post) { create(:post) }

    subject(:request) { post post_comments_path(commented_post), params: { body: } }

    context '255文字以内のコメント本文の場合' do
      include_examples :sign_in
      let(:body) { 'a' * 255 }
      it '指定した投稿にコメントすること' do
        expect { request }.to change { current_user.comments.count }.by(1)
      end
    end
  end
end
