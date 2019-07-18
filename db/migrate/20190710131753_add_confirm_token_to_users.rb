class AddConfirmTokenToUsers < ActiveRecord::Migration[5.2]
  def up
  	add_column :users , :confirmed , :boolean , default: false
  	add_column :users , :confirm_token , :string
  end

  def down
  	remove_column :users , :confirmed
  	remove_column :users ,:confirm_token
  end
end
