class CreateOauthapps < ActiveRecord::Migration[5.2]
  def change
    create_table :oauthapps do |t|
      t.integer :userid
      t.string :title
      t.string :pubkey
      t.string :secret

      t.timestamps
    end
  end
end
