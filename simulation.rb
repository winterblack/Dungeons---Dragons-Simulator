require_relative 'monster'
require_relative 'encounter'
require_relative 'player_character'

def run
    i = 1
    1000.times do
        puts
        p "Run ##{i}"
        puts
        i += 1

        monsters = Array.new(4) { Monster.new('Orc') }
        encounter = Encounter.new monsters
        party = [
            PlayerCharacter.new('Jozan'),
            PlayerCharacter.new('Tordek'),
            PlayerCharacter.new('Lidda', -30),
            PlayerCharacter.new('Mialee', -30),
        ]
        encounter.run(party)
    end
end

run if __FILE__ == $PROGRAM_NAME
