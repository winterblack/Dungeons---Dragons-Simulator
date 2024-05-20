require_relative '../player_character'
require_relative '../class_features/sneak_attack'

class Rogue < PlayerCharacter
    def initialize key
        super key, -30
        learn_sneak_attack
    end

    def learn_sneak_attack
        weapon.extend SneakAttack if weapon.ability == :dex
    end
end
