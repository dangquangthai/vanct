class AddLastSeenAtToCustomer < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :last_seen_at, :datetime
  end
end
