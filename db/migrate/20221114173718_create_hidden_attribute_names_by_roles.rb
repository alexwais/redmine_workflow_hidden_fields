class CreateHiddenAttributeNamesByRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :hidden_attribute_names_by_roles do |t|
      t.string :name
      t.references :role, foreign_key: true
    end
  end
end
