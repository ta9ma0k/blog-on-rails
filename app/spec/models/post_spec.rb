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

  describe '.likes_ranking' do
    let(:date) { Date.new(2024, 10, 1) }
    let(:limit) { 3 }
    let(:posts) { create_list(:post, 6, created_at: date.prev_month)}
    subject { described_class.likes_ranking(date, limit) }

    before do
      users = create_list(:user, 4)

      make_likes = ->(count, post, date) { count.times { |i| create(:like, post:, user: users[i], created_at: date) } }

      # 2024/10/1のいいねが1番多い
      make_likes.call(4, posts[1], date)
      # 2024/10/1のいいねが2番多い
      make_likes.call(3, posts[2], date)
      # 2024/10/1のいいねが3番多い
      make_likes.call(2, posts[3], date)
      # 2024/10/1のいいねが4番多い
      make_likes.call(1, posts[4], date)

      # 2024/10/2のいいねが1番多い
      make_likes.call(4, posts[0], date.tomorrow)
      # 2024/9/30のいいねが1番多い
      make_likes.call(4, posts[5], date.yesterday)
    end

    it '指定した日付のいいね数上位3件の投稿を取得する' do
      is_expected.to eq [posts[1], posts[2], posts[3]]
    end
  end
end
