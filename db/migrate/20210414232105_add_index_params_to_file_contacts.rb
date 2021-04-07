class AddIndexParamsToFileContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :file_contacts, :index_params, :string
  end
end
