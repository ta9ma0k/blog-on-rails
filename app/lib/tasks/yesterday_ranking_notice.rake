Rails.logger = Logger.new($stdout)

namespace :yesterday_ranking_notice do
  desc "実行日の前日のいいね数TOP10の投稿を通知する"
  task exec: :environment do |_, args|
    date = Time.zone.now.yesterday

    Rails.logger.info "#{date.strftime('%F')}のランキングを集計します"
    posts = Post.likes_ranking(date).to_a

    if posts.empty?
      Rails.logger.info "対象の投稿が存在しませんでした"
      next
    end

    Rails.logger.info "#{posts.size}件の投稿を取得しました"
    Rails.logger.debug "POST ID=#{posts.map(&:id).join(',')}"

    User.find_each do |user|
      NotificationMailer.ranking(user, posts, date).deliver_later
    end

    Rails.logger.info "#{User.count}件のメールを送信しました"
  end
end
