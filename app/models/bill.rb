class Bill < ActiveRecord::Base
  belongs_to :payee, class_name: "User", foreign_key: "payee_id"
  belongs_to :payer, class_name: "User", foreign_key: "payer_id"

  # scope :recent, -> { where("state == 'New' OR state == 'Accepted' OR state == 'Dispute' OR updated_at > " + (Time.now - 7.days)).order("updated_at DESC") }
  scope :recent, -> { where(["state = ? or state = ? or state = ? or updated_at > ?", 'New', 'Accepted', 'Dispute', (Time.now - 7.days)]).order("updated_at DESC") }
  # scope :recent_and_payed?, -> { where("state == 'New' OR state == 'Accepted' OR state == 'Dispute' OR state == 'Paid?' OR updated_at > " + (Time.now - 7.days)).order("updated_at DESC") }
  scope :recent_and_paid?, -> { where(["state = ? or state = ? or state = ? or state = ? or updated_at > ?", 'New', 'Accepted', 'Dispute', 'Paid?', (Time.now - 7.days)]).order("updated_at DESC") }
  scope :in_progress, -> { where(["state = ? or state = ? or state = ? or state = ?", 'New', 'Accepted', 'Dispute', 'Paid?']).order("updated_at DESC") }
end
