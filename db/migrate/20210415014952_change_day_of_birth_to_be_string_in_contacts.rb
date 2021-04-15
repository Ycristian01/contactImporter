class ChangeDayOfBirthToBeStringInContacts < ActiveRecord::Migration[6.1]
  def change
    change_column :contacts, :dayOfBirth, :string
  end
end
