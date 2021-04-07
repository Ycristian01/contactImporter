class RemoveContactFileFromFailedContact < ActiveRecord::Migration[6.1]
  def change
    remove_reference :failed_contacts, :contact_file, null: false, foreign_key: true
  end
end
