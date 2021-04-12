class AddEncryptedCardNumberToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :encrypted_card_number, :string
  end
end
