class AddProfileToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :profile, :string, limit: 200, comment: 'プロフィールコメント'
    add_column :users, :blog_url, :string, comment: 'ブログURL'
  end
end
