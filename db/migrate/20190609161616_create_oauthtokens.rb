class CreateOauthtokens < ActiveRecord::Migration[5.2]
  def change
    create_table :oauthtokens do |t|
      t.string :key
      t.string :access_token
      t.string :refresh_token
      t.string :scope
      t.string :state
      t.string :token_type
      t.integer :user_id
      t.timestamp :expires

      t.timestamps
    end
  end
end
