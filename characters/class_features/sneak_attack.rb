module SneakAttack
    def average_damage
        super + sneak_attack_average
    end

    private

    def sneak_attack_dice
        @sneak_attack_dice ||= Dice.new "#{(character.level + 1)/2}d6"
    end

    def sneak_attack_average
        sneaking? ? sneak_attack_dice.average : 0
    end

    def sneaking?
        return false if advantage_disadvantage == :disadvantage
        advantage_disadvantage == :advantage || target.foes_within(5).any?
    end

    def roll_damage
        super + roll_sneak_attack
    end

    def roll_sneak_attack
        return 0 unless sneaking?
        p "#{character.name} sneak attacks #{target.name}"
        sneak_attack_dice.roll critical_hit
    end
end
