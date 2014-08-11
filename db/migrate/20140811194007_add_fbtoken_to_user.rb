class AddFbtokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :fbtoken, :string
  end
end
