require 'require_all'
require 'yaml'
require_relative 'encounter'
require_relative 'characters/monster'
require_all 'characters/classes'

Monsters = YAML.load(File.read 'monsters.yaml')
Characters = YAML.load(File.read 'player_characters.yaml')

def run
    i = 1
    1000.times do
        puts
        p "Run ##{i}"
        puts
        i += 1

        monsters = Array.new(8) { |i| Monster.new(Monsters['Kobold'], "Kobold-#{i+1}") }
        encounter = Encounter.new monsters
        party = [
            Cleric.new(Characters['cleric']),
            Fighter.new(Characters['fighter']),
            Rogue.new(Characters['rogue']),
            Wizard.new(Characters['wizard']),
        ]
        encounter.run(party)
    end
end

run if __FILE__ == $PROGRAM_NAME
