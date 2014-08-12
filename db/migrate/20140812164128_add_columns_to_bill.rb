class AddColumnsToBill < ActiveRecord::Migration
  def change
    add_column :bills, :splits_to, :integer
    add_column :bills, :state, :string
  end
end
