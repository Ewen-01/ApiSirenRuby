class CreateSirens < ActiveRecord::Migration[7.0]
  def change
    create_table :sirens do |t|
      t.string :code_siren
      t.string :nom_entreprise
      t.string :adresse
      t.string :code_postal
      t.string :ville

      t.timestamps
    end
  end
end
