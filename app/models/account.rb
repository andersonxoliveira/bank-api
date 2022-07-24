class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  accepts_nested_attributes_for :user, reject_if: :all_blank

  before_validation :set_code

  private

  def set_code
    self.code = rand(1..9).to_s+rand(100..800).to_s+rand(100..999).to_s
  end
end
