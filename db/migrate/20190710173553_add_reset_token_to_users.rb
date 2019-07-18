class AddResetTokenToUsers < ActiveRecord::Migration[5.2]
  def up
  	add_column :users , :reset_token ,:string
  end
  def down
  	remove_column :users , :reset_token 
  end
end
