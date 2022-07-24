class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code
      t.integer :status
      t.float :score

      t.timestamps
    end
  end
end
