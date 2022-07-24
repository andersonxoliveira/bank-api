class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :destination_account, class_name: "Account"

  after_initialize :check_destination_account

  enum transaction_type: {
    deposit: 0,
    withdrawal: 1,
    transfers_between_accounts: 2
  }, _prefix: :transaction_type

  private

  def check_destination_account
    if ([self.transaction_type] & ["deposit", "withdrawal"]).present?
      self.destination_account = self.account
    end
  end
end
