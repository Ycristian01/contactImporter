class AddContactFileReferenceToContacts < ActiveRecord::Migration[6.1]
  def change
    add_reference :contacts, :contact_file, null: false, foreign_key: true
  end
end
