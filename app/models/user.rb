class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :charges, class_name: "Bill", foreign_key: "payee_id"
  has_many :bills, class_name: "Bill", foreign_key: "payer_id"

  has_many :debtors, -> { where(["state = ? or state = ? or state = ? or state = ?", 'New', 'Accepted', 'Dispute', 'Paid?']).uniq }, through: :charges, source: :payer
  has_many :creditors, -> { where(["state = ? or state = ? or state = ? or state = ?", 'New', 'Accepted', 'Dispute', 'Paid?']).uniq }, through: :bills, source: :payee
  has_many :recent_debtors, -> { where(["state = ? or state = ? or state = ? or state = ? or bills.updated_at > ?", 'New', 'Accepted', 'Dispute', 'Paid?', (Time.now - 7.days)]).uniq }, through: :charges, source: :payer
  has_many :recent_creditors, -> { where(["state = ? or state = ? or state = ? or bills.updated_at > ?", 'New', 'Accepted', 'Dispute', (Time.now - 7.days)]).uniq }, through: :bills, source: :payee

  def avator_path(size)
    "https://graph.facebook.com/" + fbid.to_s + "/picture?width=" + size.to_s + "&height=" + size.to_s
  end

  def self.from_facebook(auth)
    user = where({:fbid => auth.uid}).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
    user.name = auth.info.name
    user.email = auth.info.email
    user.fbtoken = auth.credentials.token
    user.save
    return user
  end
end
