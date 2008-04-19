class AddExtraSpamColumnsToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :author_ip,      :string, :null => false
    add_column :comments, :author_referer, :string, :null => false
  end

  def self.down
    remove_column :comments, :author_ip
    remove_column :comments, :author_referer
  end
end
