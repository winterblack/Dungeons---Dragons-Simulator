require_relative 'action'

class Weapon < Action
    attr_reader :name, :damage_dice, :finesse, :ranged
    attr_reader :range
    attr_reader :target, :hit

    Weapons = YAML.load(File.read 'weapons.yaml')

    def initialize key, character
        weapon = Weapons[key]
        @name = key
        @damage_dice = weapon['damage']
        @finesse = weapon['finesse']
        @ranged = weapon['ranged']
        @range = weapon['range'] || 5
        super character
    end

    def perform
        target = choose_target
        move_into_position
        attack target
    end

    def attack target
        @target = target
        roll_to_hit
        @hit ? strike : miss
    end

    def valid_targets?
        !valid_targets.empty?
    end

    private

    def move_into_position
        distance = distance_to_target - range
        character.move distance * direction_to_target
    end

    def miss
        p "#{character.name} misses #{target.name}"
    end

    def strike
        damage = Dice(damage_dice).roll + ability_bonus
        p "#{character.name} hits #{target.name} for #{damage} damage with #{name}"
        target.take damage
    end

    def ability_bonus
        (ranged || finesse) ? dex : str
    end

    def attack_roll
        D20.roll + proficiency_bonus + ability_bonus
    end

    def roll_to_hit
        @hit = (attack_roll != 1 && attack_roll > target.ac)
    end

    def valid_targets
        foes_within(character.speed + range).reject(&:dead)
    end

    def choose_target
        @target = valid_targets.min_by(&:current_hp)
    end

    def direction_to_target
        character.direction_to target
    end

    def distance_to_target
        character.distance_to target
    end

    def foes_within distance
        character.foes_within distance
    end

    def proficiency_bonus
        character.proficiency_bonus
    end

    def str
        character.str
    end

    def dex
        character.dex
    end
end
