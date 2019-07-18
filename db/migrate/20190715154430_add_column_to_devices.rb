class AddColumnToDevices < ActiveRecord::Migration[5.2]
  def up
  	add_column 'devices' , 'logged_in' , :boolean , default: true
  end

  def down
  	add_column 'devices' , 'logged_in'
  end
end
