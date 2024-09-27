require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '.recently' do
    subject { described_class.recently }

    let!(:post1) { create(:post, posted_at: DateTime.new(2024, 9, 1, 9, 0, 1)) }
    let!(:post2) { create(:post, posted_at: DateTime.new(2024, 9, 1, 9, 0, 2)) }
    let!(:post3) { create(:post, posted_at: DateTime.new(2024, 9, 1, 8, 0, 0)) }

    it '投稿日時で降順に投稿が表示されること' do
      is_expected.to eq [post2, post1, post3]
    end
  end
end
