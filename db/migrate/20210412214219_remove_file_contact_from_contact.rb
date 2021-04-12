class RemoveFileContactFromContact < ActiveRecord::Migration[6.1]
  def change
    remove_reference :contacts, :file_contact, null: false, foreign_key: true
  end
end
