class ChangeDayOfBirthToBeStringInFailedContacts < ActiveRecord::Migration[6.1]
  def change
    change_column :failed_contacts, :dayOfBirth, :string
  end
end
