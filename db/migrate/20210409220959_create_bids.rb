class CreateBids < ActiveRecord::Migration[6.0]
  def change
    create_table :bids do |t|
      t.references :user
      t.references :auction
      t.integer :amount
      t.datetime :time

      t.timestamps
    end
  end
end
