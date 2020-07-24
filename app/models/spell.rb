class Spell < ApplicationRecord
    has_many :klass_spells
    has_many :character_spells
    has_many :klasses, through: :klass_spells
    has_many :characters, through: :character_spells


    def self.fetch_all_spells
        response = RestClient.get("http://www.dnd5eapi.co/api/spells")
        spells = JSON.parse(response.body)
        spells["results"].length.times { |i|
            spell = JSON.parse(RestClient.get("http://www.dnd5eapi.co#{spells['results'][i]['url']}").body)
            Spell.new(name: spells['results'][i]['name'], level: spell['level'], desc: spell['desc']).save
        }   
    end

    def self.load_class_spell_list(character_class)
        spell_list = JSON.parse(RestClient.get("http://www.dnd5eapi.co/api/classes/#{character_class.name}/spells").body)    
        spell_list['count'].times { |i|
            spell = JSON.parse(RestClient.get("http://www.dnd5eapi.co#{spell_list['results'][i]['url']}").body)
            Spell.new(name: spell_list['results'][i]['name'], level: spell['level'], desc: spell['desc'], character_class_id: character_class.id).save
            
        }
    end
end