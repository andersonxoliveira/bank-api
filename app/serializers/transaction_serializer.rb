class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attributes :id, :value, :status, :transaction_type, :account, :destination_account
end
