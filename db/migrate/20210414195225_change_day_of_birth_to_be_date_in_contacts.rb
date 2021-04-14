class ChangeDayOfBirthToBeDateInContacts < ActiveRecord::Migration[6.1]
  def change
    change_column :contacts, :dayOfBirth, :date
  end
end
