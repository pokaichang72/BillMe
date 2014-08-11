class AddPayeeIdToBill < ActiveRecord::Migration
  def change
    add_column :bills, :payee_id, :integer
  end
end
