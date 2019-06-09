class CreateOauthcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :oauthcodes do |t|
      t.string :key
      t.string :code
      t.string :scope
      t.string :state
      t.string :redirect_uri
      t.timestamp :expires

      t.timestamps
    end
  end
end
