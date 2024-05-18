class Weapon
    attr_reader :name, :damage_dice, :finesse, :ranged
    attr_reader :target
    attr_accessor :character

    Weapons = YAML.load(File.read 'weapons.yaml')

    def initialize name
        weapon = Weapons[name]
        @name = name
        @damage_dice = weapon['damage']
        @finesse = weapon['finesse']
        @ranged = weapon['ranged']
    end

    def perform
        @target = choose_target
        attack target
    end

    private

    def attack target
        roll_to_hit
        @hit ? strike : miss
    end

    def miss
        p "#{character.name} misses #{target.name}"
    end

    def strike
        damage = Dice(damage_dice).roll + ability_bonus
        p "#{character.name} hits #{target.name} for #{damage} damage"
        target.take damage
    end

    def ability_bonus
        (ranged || finesse) ? character.dex : character.str
    end

    def attack_roll
        D20.roll + character.proficiency_bonus + ability_bonus
    end

    def roll_to_hit
        @hit = (attack_roll != 1 && attack_roll > target.ac)
    end

    def choose_target
        @target = character.foes.reject(&:dead).max_by(&:initiative)
    end
end
