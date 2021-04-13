class AddContactErrorsToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :contact_errors, :string
    add_column :contacts, :valid_contact, :boolean
  end
end
