require_relative 'action'
require_relative 'target_value'

class Weapon < Action
    attr_reader :name, :damage_dice, :finesse, :ranged
    attr_reader :range
    attr_reader :target, :hit, :should_move

    Weapons = YAML.load(File.read 'weapons.yaml')

    def initialize key, character
        weapon = Weapons[key]
        @name = key
        @damage_dice = Dice.new weapon['damage']
        @finesse = weapon['finesse']
        @ranged = weapon['ranged']
        @range = weapon['range'] || 5
        @should_move = true
        super character
    end

    def perform
        choose_target
        move_into_position if should_move
        p "#{character.name} decided not to move and to attack with disadvantage to avoid opportunity attacks" unless should_move
        p "#{character.name} decided to risk opportunity attacks to attack without disadvantage" if should_move && @risky
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

    def evaluate_target target
        hit_chance(target) * evaluate_damage(target)
    end

    private

    def evaluate_damage target
        [average_damage / target.current_hp, 1].min
    end

    def evaluate_target_ranged target
        ranged_hit_chance(target) * evaluate_damage(target)
    end

    def ranged_hit_chance target
        chance = hit_chance target
        ranged_attack_in_close_combat ? chance**2 : chance
    end

    def hit_chance target
        chance = (21 - target.ac + to_hit_bonus)/20.0
        return 0.95 if chance > 0.95
        return 0.05 if chance < 0.05
        chance
    end

    def average_damage
        damage_dice.average + ability_bonus
    end

    def move_into_position
        character.move(movement_into_position(target), target)
    end

    def movement_into_position target
        (character.distance_to(target) - range) * character.direction_to(target)
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
        p "#{character.name}#{" critically" if @critical_hit} hits #{target.name} for #{damage} damage with #{name}"
    end

    def ability_bonus
        (ranged || finesse) ? character.dex.bonus : character.str.bonus
    end

    def attack_roll
        roll = ranged_attack_in_close_combat ? D20.roll(:disadvantage) : D20.roll
        @critical_miss = roll == 1
        @critical_hit = roll == 20
        roll + to_hit_bonus
    end

    def ranged_attack_in_close_combat
        ranged && character.foes_within(5).any?
    end

    def to_hit_bonus
        proficiency_bonus + ability_bonus
    end

    def roll_to_hit
        @hit = attack_roll >= target.ac && !@critical_miss || @critical_hit
    end

    def valid_targets
        foes_within max_distance
    end

    def choose_target
        @target = ranged ? choose_ranged_target : choose_melee_target
    end

    def target_with_movement
        targets_with_movement.max_by(&:value)
    end

    def targets_with_movement
        valid_targets.map do |target|
            TargetValue.new(target, evaluate_target_with_risk(target))
        end
    end

    def target_without_movement
        targets_without_movement.max_by(&:value)
    end

    def targets_without_movement
        foes_within(range).map do |target|
            TargetValue.new(target, evaluate_target_ranged(target))
        end
    end

    def choose_ranged_target
        @should_move = foes_within(range).empty? || target_with_movement.value >= target_without_movement.value
        @risky = evaluate_risk(target_with_movement.target) > 0
        should_move ? target_with_movement.target : target_without_movement.target
    end

    def choose_melee_target
        valid_targets.max { |target| evaluate_target_with_risk target }
    end

    def evaluate_target_with_risk target
        evaluate_target(target) - evaluate_risk(target)
    end

    def evaluate_risk target
        destination = character.position + movement_into_position(target)
        character.foes_in_path_to(destination).select(&:reaction).map do |foe|
            foe.weapon.evaluate_target character
        end.sum
    end

    def max_distance
        character.speed + range + (character.aggressive ? character.speed : 0)
    end

    def direction_to_target
        character.direction_to target
    end

    def foes_within distance
        character.foes_within distance
    end

    def proficiency_bonus
        character.proficiency_bonus
    end
end
