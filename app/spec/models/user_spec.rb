require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#post' do
    let(:user) { create(:user) }
    subject(:sut) { user.post(body) }
    
    context '140文字以内の投稿の場合' do
      let(:body) { 'post body' }
      it { is_expected.not_to be_nil }
      it { expect { sut }.to change { user.posts.count }.by(1) }
    end
    context '140文字以上の投稿の場合' do
      let(:body) { 'x' * 141 }
      it { is_expected.to be_nil }
      it { expect { sut }.not_to change { user.posts.count } }
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
end
