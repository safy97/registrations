class CreateDevice < ActiveRecord::Migration[5.2]
  def up
    create_table :devices do |t|
      t.belongs_to :user, index: true
      t.string :uuid
      t.timestamps
    end
  end

  def down 
  	drop_table "devices"
  end
end
