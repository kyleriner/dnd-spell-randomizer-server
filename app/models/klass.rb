class Klass < ApplicationRecord
    has_many :character_klasses
    has_many :klass_spells
    has_many :characters, through: :character_klasses
    has_many :spells, through: :klass_spells
    accepts_nested_attributes_for :character_klasses, reject_if: :all_blank


end