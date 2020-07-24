class CreateCharacterKlasses < ActiveRecord::Migration[6.0]
  def change
    create_table :character_klasses do |t|
      t.integer :character_id
      t.integer :klass_id
      t.integer :level
    end
  end
end
