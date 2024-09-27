class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :body, null: false, limit: 140, comment: '投稿内容'
      t.timestamps
    end
  end
end
