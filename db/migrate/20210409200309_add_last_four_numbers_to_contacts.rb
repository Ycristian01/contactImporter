class AddLastFourNumbersToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :last_four_numbers, :string
  end
end
