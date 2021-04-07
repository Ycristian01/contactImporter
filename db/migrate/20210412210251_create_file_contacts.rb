class CreateFileContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :file_contacts do |t|
      t.string :name
      t.string :status

      t.timestamps
      
    end
    add_column :contacts, :file_contact_id, :integer
    add_foreign_key :contacts, :file_contacts, column: :file_contact_id
  end
end
