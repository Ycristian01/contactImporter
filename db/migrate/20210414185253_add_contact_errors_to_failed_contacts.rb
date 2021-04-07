class AddContactErrorsToFailedContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :failed_contacts, :contact_errors, :string
  end
end
