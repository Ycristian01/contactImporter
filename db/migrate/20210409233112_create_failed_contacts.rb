class CreateFailedContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :failed_contacts do |t|
      t.string :name
      t.string :dayOfBirth
      t.integer :phone
      t.string :address
      t.string :card
      t.string :franchise
      t.string :email
      t.string :last_four_numbers
      t.references :contact_file, foreign_key: true, index: true

      t.timestamps
    end
  end
end
