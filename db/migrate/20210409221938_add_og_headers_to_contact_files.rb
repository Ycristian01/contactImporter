class AddOgHeadersToContactFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :contact_files, :og_headers, :text, array: true
  end
end
