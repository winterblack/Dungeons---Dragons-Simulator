require 'require_all'
require_relative 'encounter'
require_relative 'characters/monster'
require_all 'characters/classes'

def run
    i = 1
    1000.times do
        puts
        p "Run ##{i}"
        puts
        i += 1

        monsters = Array.new(4) { Monster.new('Kobold') }
        encounter = Encounter.new monsters
        party = [
            Cleric.new('Jozan'),
            Fighter.new('Tordek'),
            Rogue.new('Lidda'),
            Wizard.new('Mialee'),
        ]
        encounter.run(party)
    end
end

run if __FILE__ == $PROGRAM_NAME
