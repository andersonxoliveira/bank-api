class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  accepts_nested_attributes_for :user, reject_if: :all_blank
  before_validation :set_intial_values

  enum status: {
    active: 0,
    disabled: 1
  }, _prefix: :status

  private

  def set_intial_values
    self.code = rand(1..9).to_s+rand(100..800).to_s+rand(100..999).to_s
    self.status = :active
    self.score = 0
  end
end
