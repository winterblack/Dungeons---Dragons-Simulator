module RangedWeapon
    def ability_bonus
        character.dex.bonus
    end

    def ability
        :dex
    end

    def advantage_disadvantage
        position = @destination || character.position
        character.foes_within_radius_of(position, 5).any? ? :disadvantage : nil
    end

    def choose_target
        with_movement = target_with_movement
        without_movement = target_without_movement
        @should_move = foes_within(range).empty? || with_movement.value >= without_movement.value
        @risky = evaluate_risk(with_movement.target) > 0
        @target = should_move ? with_movement.target : without_movement.target
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
            TargetValue.new(target, evaluate_target(target))
        end
    end

    def evaluate_target_with_risk target
        @target = target
        @destination = character.position + movement_into_position
        super target
    end
end
