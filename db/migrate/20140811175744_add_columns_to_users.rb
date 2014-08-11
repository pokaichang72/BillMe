class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :fbid, :string
    add_column :users, :name, :string
  end
end
