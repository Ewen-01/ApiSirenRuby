class AddAuthorizationToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :authorization, :boolean, default: true
  end
end
