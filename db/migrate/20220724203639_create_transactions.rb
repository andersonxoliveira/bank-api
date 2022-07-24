class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.float :value
      t.integer :transaction_type
      t.integer :status
      t.references :account, foreign_key: true
      t.integer :destination_account_id

      t.timestamps
    end
    add_index :transactions, :destination_account_id
  end
end
