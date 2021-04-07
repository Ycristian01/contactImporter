class RemoveContactFileFromContact < ActiveRecord::Migration[6.1]
  def change
    remove_reference :contacts, :contact_file, null: false, foreign_key: true
  end
end
