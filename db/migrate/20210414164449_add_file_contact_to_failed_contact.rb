class AddFileContactToFailedContact < ActiveRecord::Migration[6.1]
  def change
    add_reference :failed_contacts, :file_contact, null: false, foreign_key: true
  end
end
