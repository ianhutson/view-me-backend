class AddHeartsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :hearts, :integer
  end
end
