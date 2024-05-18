require_relative 'character'
require_relative 'encounter'

def run
    monsters = Array.new(4) { Character.new({ name: 'Goblin', hp: 7, ac: 15, speed: 30 })}
    encounter = Encounter.new(monsters)
    party = [
        Character.new({ name: 'Jozan', hp: 10, ac: 16, speed: 30 }),
        Character.new({ name: 'Tordek', hp: 10, ac: 16, speed: 30 }),
        Character.new({ name: 'Lidda', hp: 10, ac: 16, speed: 30 }),
        Character.new({ name: 'Mialee', hp: 10, ac: 16, speed: 30 }),
    ]
    encounter.run(party)
end

run if __FILE__ == $PROGRAM_NAME
