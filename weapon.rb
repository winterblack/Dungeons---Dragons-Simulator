require_relative 'action'

class Weapon < Action
    attr_reader :name, :damage_dice, :finesse, :ranged
    attr_reader :range
    attr_reader :target, :hit

    Weapons = YAML.load(File.read 'weapons.yaml')

    def initialize key, character
        weapon = Weapons[key]
        @name = key
        @damage_dice = Dice.new weapon['damage']
        @finesse = weapon['finesse']
        @ranged = weapon['ranged']
        @range = weapon['range'] || 5
        super character
    end

    def perform
        target = choose_target
        move_into_position
        attack target unless character.dead
    end

    def attack target
        @target = target
        roll_to_hit
        hit ? strike : miss
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
        damage = damage_dice.roll(@critical_hit) + ability_bonus
        strike_message damage
        target.take damage
    end

    def strike_message damage
        p "#{character.name}#{" critically" if @critical_hit} hit #{target.name} for #{damage} damage with #{name}"
    end

    def ability_bonus
        (ranged || finesse) ? dex : str
    end

    def attack_roll
        roll = D20.roll
        @critical_miss = roll == 1
        @critical_hit = roll == 20
        roll + to_hit_bonus
    end

    def to_hit_bonus
        proficiency_bonus + ability_bonus
    end

    def roll_to_hit
        @hit = attack_roll >= target.ac && !@critical_miss || @critical_hit
    end

    def valid_targets
        foes_within(max_distance).reject(&:dead)
    end

    def choose_target
        @target = valid_targets.max { |target| evaluate_target target }
    end

    def evaluate_target target
        average_damage = damage_dice.average + ability_bonus
        hit_chance = (21 - target.ac + to_hit_bonus)/20.0
        hit_chance = 0.95 if hit_chance > 0.95
        hit_chance = 0.05 if hit_chance < 0.05
        hit_chance * average_damage / target.current_hp
    end

    def max_distance
        character.speed + range + (character.aggressive ? character.speed : 0)
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
