class RemoveOgHeadersFromContactFiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :contact_files, :og_headers, :text
  end
end
