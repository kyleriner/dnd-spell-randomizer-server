# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

klasses = JSON.parse(RestClient.get("http://www.dnd5eapi.co/api/classes/").body) 
klasses['results'].each { |klass|
    Klass.new(name: (klass['name'].downcase)).save
}


response = RestClient.get("http://www.dnd5eapi.co/api/spells")
spells = JSON.parse(response.body)
spells["results"].length.times { |i|
    spell = JSON.parse(RestClient.get("http://www.dnd5eapi.co#{spells['results'][i]['url']}").body)
    components = spell['components'].join(', ')
    desc = spell['desc'].join(" ")
    if (spell['higher_level']) 
        higher_level = spell['higher_level'].join(" ")
    end

    link = 'dndbeyond.com/spells/' + spell['index']
    Spell.new(
        name: spell['name'],
        desc: desc,
        higher_level: higher_level,
        link: link,
        range: spell['range'],
        components: components,
        material: spell['material'],
        ritual: spell['ritual'],
        duration: spell['duration'],
        concentration: spell['concentration'],
        casting_time: spell['casting_time'],
        level: spell['level'],
        school: spell['school']['name']
        ).save
 }   

 
 Klass.all.each { |klass|
    spell_list = JSON.parse(RestClient.get("http://www.dnd5eapi.co/api/classes/#{(klass.name.downcase)}/spells").body)
    if spell_list['count'] != 0
        spell_list['results'].each { |spell|
            match = Spell.all.find { |x| x.name == spell['name']}
            klass.spells.push(match)
            
        }
    end
 }
