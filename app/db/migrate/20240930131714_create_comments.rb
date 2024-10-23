class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.string :body, null: false, comment: '投稿へのコメント本文'
      t.timestamps
    end
  end
end
