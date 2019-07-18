class AddLoggedInCheckToUsers < ActiveRecord::Migration[5.2]
  def up
  	add_column :users , :logged_in , :boolean , default: false
  end
  def down
  	remove_column :users , :logged_in
  end
end
