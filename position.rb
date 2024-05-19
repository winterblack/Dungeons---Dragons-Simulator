class Position
    attr_accessor :position, :dash

    def dash_forward
        p "#{name} dashes forward"
        dash = true
        move displacement_to(closest_foe)
    end

    def direction_to target
        direction_of displacement_to(target)
    end

    def distance_to target
        displacement_to(target).abs
    end

    def foes_within range
        foes.select { |foe| distance_to(foe) <= range }
    end


    def move movement
        limited_movement = limit_speed movement
        p "#{name} is aggressive and moves #{limited_movement.abs} feet" if aggressive && limited_movement.abs > speed
        provoke_opportunity_attacks limited_movement
        self.position += limited_movement
    end

    private

    def direction_of movement
        movement.positive? ? 1 : -1
    end

    def provoke_opportunity_attacks movement
        destination = position + movement
        foes_in_path_to(destination).each do |foe|
            p "#{foe.name} makes an opportunity attack against #{self.name}"
            foe.attack self
        end
    end

    def foes_in_path_to destination
        displacement = destination - position
        distance = displacement.abs
        direction = direction_of displacement
        foes.select do |foe|
            direction_to(foe) == direction && distance_to(foe) < distance
        end.reject do |foe|
            foe.weapon.ranged
        end.select do |foe|
            (foe.position - destination).abs > foe.weapon.range
        end
    end

    def limit_speed movement
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
