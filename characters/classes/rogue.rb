require_relative '../player_character'
require_relative '../class_features/sneak_attack'

class Rogue < PlayerCharacter
    def initialize character
        super character, -30
        learn_sneak_attack
    end

    def learn_sneak_attack
        weapon.extend SneakAttack if weapon.ability == :dex
    end
end
