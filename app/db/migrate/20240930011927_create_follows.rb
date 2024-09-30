class CreateFollows < ActiveRecord::Migration[7.2]
  def change
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :followee, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :follows, [:user_id, :followee_id], unique: true
  end
end
