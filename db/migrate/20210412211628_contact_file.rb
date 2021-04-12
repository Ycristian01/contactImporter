class ContactFile < ActiveRecord::Migration[6.1]
  def change
    drop_table :contact_files
  end
end
