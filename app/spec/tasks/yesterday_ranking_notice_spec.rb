require "rake_helper"

describe "yesterday_ranking_notice:exec", type: :task do
  let(:users) { create_list(:user, 2) }
  let(:date) { Time.zone.parse('2024-10-01 10:00:00') }

  subject(:task) { Rake::Task["yesterday_ranking_notice:exec"] }

  before do
    posts = create_list(:post, 3, user: users.first)
    posts.each do |post|
      create(:like, post:, user: users.first, created_at: date.yesterday)
      create(:like, post:, user: users.last, created_at: date.yesterday)
    end
  end


  context 'ランキング対象の投稿が存在する場合' do
    before { travel_to(date) }
    it 'ユーザにランキング通知が送信されること' do
      expect { perform_enqueued_jobs { task.invoke } }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end
  context 'ランキング対象の投稿が存在しない場合' do
    before { travel_to(date.tomorrow) }
    it 'ユーザにランキング通知が送信されないこと' do
      expect { perform_enqueued_jobs { task.invoke } }.not_to change { ActionMailer::Base.deliveries.count }
    end
  end
end
