class ChangePhoneToBeStringInFailedContacts < ActiveRecord::Migration[6.1]
  def change
    change_column :failed_contacts, :phone, :string
  end
end
