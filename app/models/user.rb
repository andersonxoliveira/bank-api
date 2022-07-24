# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  belongs_to :account
  # has_many :transactions, through: :account

  before_validation :set_account
  before_validation :set_uid

  private

  def set_account
    self.account = Account.create(status: 0, score: 0, code: rand(1..9).to_s+rand(10..80).to_s+rand(100..999).to_s)
  end
  def set_uid
    self.uid = self.email if self.uid.blank? && self.email.present?
  end
end
