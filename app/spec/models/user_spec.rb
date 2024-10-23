require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#post' do
    let(:user) { create(:user) }
    subject(:sut) { user.post(body, thumbnail) }

    context '140文字以内の投稿の場合' do
      let(:body) { 'post body' }
      let(:thumbnail) { nil }
      it { is_expected.not_to be_nil }
      it { expect { sut }.to change { user.posts.count }.by(1) }
    end
    context '画像を含む投稿の場合' do
      let(:body) { 'post body' }
      let(:thumbnail) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), 'image/png') }
      it { is_expected.not_to be_nil }
      it 'サムネイル画像付きの投稿が作成されること' do
        expect { sut }.to change { user.posts.count }.by(1)
        post = user.posts.last
        expect(post.thumbnail).to be_attached
      end
    end
    context '140文字以上の投稿の場合' do
      let(:body) { 'x' * 141 }
      let(:thumbnail) { nil }
      it { is_expected.to be_nil }
      it { expect { sut }.not_to change { user.posts.count } }
    end
  end

  describe '#posted?' do
    let(:user) { create(:user) }
    subject { user.posted?(post) }

    context 'ユーザが投稿した投稿の場合' do
      let(:post) { create(:post, user:) }
      it { is_expected.to be true }
    end
    context 'ユーザが投稿していない投稿の場合' do
      let(:post) { create(:post) }
      it { is_expected.to be false }
    end
  end

  describe '#follow?' do
    let(:user) { create(:user) }
    let(:arg_user) { create(:user) }

    subject { user.follow?(arg_user) }

    context 'フォローしているユーザの場合' do
      before { create(:follow, user:, followee: arg_user) }

      it { is_expected.to be true }
    end
    context 'フォローしていないユーザの場合' do
      it { is_expected.to be false }
    end
  end

  describe '#follow' do
    let(:user) { create(:user) }
    let(:arg_user) { create(:user) }

    subject(:sut) { user.follow(arg_user) }

    context 'フォローしているユーザの場合' do
      before { create(:follow, user:, followee: arg_user) }

      it { is_expected.to be false }
      it { expect { sut }.not_to change { user.follows.count } }
    end
    context 'フォローしていないユーザの場合' do
      it { is_expected.to be true }
      it { expect { sut }.to change { user.follows.count }.by(1) }
    end
  end

  describe '#unfollow' do
    let(:user) { create(:user) }
    let(:arg_user) { create(:user) }

    subject(:sut) { user.unfollow(arg_user) }

    context 'フォローしているユーザの場合' do
      before { create(:follow, user:, followee: arg_user) }

      it { is_expected.to be true }
      it { expect { sut }.to change { user.follows.count }.by(-1) }
    end
    context 'フォローしていないユーザの場合' do
      it { is_expected.to be false }
      it { expect { sut }.not_to change { user.follows.count } }
    end
  end

  describe '#like?' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    subject { user.like?(post) }

    context 'いいねしている投稿の場合' do
      before { create(:like, user:, post:) }

      it { is_expected.to be true }
    end
    context 'いいねしていない投稿の場合' do
      it { is_expected.to be false }
    end
  end

  describe '#like' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    subject(:sut) { user.like(post) }

    context 'いいねしている投稿の場合' do
      before { create(:like, user:, post:) }

      it { is_expected.to be false }
      it { expect { sut }.not_to change { user.likes.count } }
    end
    context 'いいねしていない投稿の場合' do
      it { is_expected.to be true }
      it { expect { sut }.to change { user.likes.count }.by(1) }
    end
  end

  describe '#unlike' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    subject(:sut) { user.unlike(post) }

    context 'いいねしている投稿の場合' do
      before { create(:like, user:, post:) }

      it { is_expected.to be true }
      it { expect { sut }.to change { user.likes.count }.by(-1) }
    end
    context 'いいねしていない投稿の場合' do
      it { is_expected.to be false }
      it { expect { sut }.not_to change { user.likes.count } }
    end
  end

  describe '#comment' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    subject(:sut) { user.comment(post, body) }

    context '255文字以内のコメント本文の場合' do
      let(:body) { 'a' * 255 }

      it { is_expected.to be true }
      it { expect { sut }.to change { user.comments.count }.by(1) }
      it 'コメントした投稿のユーザに通知が送信されること' do
        expect { sut }.to change { ActionMailer::Base.deliveries.count }.by(1)
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to.first).to eq post.user.email
        expect(mail.subject).to eq 'コメントされました！'
      end
    end

    context '255文字以上のコメント本文の場合' do
      let(:body) { 'a' * 256 }

      it { is_expected.to be false }
      it { expect { sut }.not_to change { user.comments.count } }
    end
  end
end
