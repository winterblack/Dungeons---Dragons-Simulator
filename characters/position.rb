class Position
    attr_accessor :position, :dash

    def dash_forward
        move(displacement_to(closest_foe), closest_foe, true)
    end

    def direction_to target
        direction_of displacement_to(target)
    end

    def distance_to target
        displacement_to(target).abs
    end

    def foes_within range
        foes.reject(&:dead).select { |foe| distance_to(foe) <= range }
    end

    def move movement, target, dash=false
        direction = direction_of(movement) == direction_to(target) ? "towards" : "away from"
        limited_movement = limit_speed movement, dash
        distance = limited_movement.abs
        p "#{name} #{dash ? "dashes" : "moves"}#{" aggressively" if aggressive && distance > speed} #{distance} feet #{direction} #{target.name}" if movement.abs > 0
        provoke_opportunity_attacks limited_movement
        actually_move limited_movement unless dead
    end

    def foes_in_path_to destination
        displacement = destination - position
        distance = displacement.abs
        direction = direction_of displacement
        foes_in_path = foes.reject(&:dead).select do |foe|
            direction_to(foe) == direction &&
            distance_to(foe) < distance &&
            (foe.position - destination).abs > foe.weapon.range
        end
        (foes_in_path + foes_within(5)).reject { |foe| foe.weapon.is_a? RangedWeapon }
    end

    def foes_within_radius_of position, radius
        foes.reject(&:dead).select { |foe| distance_between(foe, position) <= radius }
    end

    private

    def distance_between target, position
        (target.position - position).abs
    end

    def actually_move movement
        self.position += movement
    end

    def direction_of movement
        movement.positive? ? 1 : -1
    end

    def provoke_opportunity_attacks movement
        destination = position + movement
        foes_in_path_to(destination).each do |foe|
            foe.opportunity_attack self
        end
    end

    def limit_speed movement, dash
        distance = movement.abs
        direction = direction_of movement
        limit = speed + (aggressive ? speed : 0) + (dash ? speed : 0)
        distance > limit ? limit * direction : movement
    end

    def closest_foe
        foes.reject(&:dead).min { |foe| distance_to foe }
    end

    def displacement_to target
        target.position - position
    end
end
