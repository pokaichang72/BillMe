class AddPayerIdToBill < ActiveRecord::Migration
  def change
    add_column :bills, :payer_id, :integer
  end
end
