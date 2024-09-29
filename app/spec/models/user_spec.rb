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
end
