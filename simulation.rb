require_relative 'monster'
require_relative 'encounter'
require_relative 'player_character'

def run
    monsters = Array.new(4) { Monster.new('goblin') }
    encounter = Encounter.new monsters
    party = [
        PlayerCharacter.new('Jozan'),
        PlayerCharacter.new('Tordek'),
        PlayerCharacter.new('Lidda', -30),
        PlayerCharacter.new('Mialee', -30),
    ]
    encounter.run(party)
end

run if __FILE__ == $PROGRAM_NAME
