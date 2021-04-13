class AddFileContactToContact < ActiveRecord::Migration[6.1]
  def change
  end
  add_column :contacts, :file_contact_id, :integer
  add_foreign_key :contacts, :file_contacts, column: :file_contact_id
end
