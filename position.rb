class Position
    attr_accessor :position

    def dash_forward
        p "#{name} dashes forward"
        move displacement_to(closest_foe), true
    end

    def direction_to target
        displacement_to(target).positive? ? 1 : -1
    end

    def distance_to target
        displacement_to(target).abs
    end

    def foes_within range
        foes.select { |foe| distance_to(foe) < range + 1 }
    end


    def move movement, dash=false
        self.position += limit_speed movement, dash
    end

    private

    def limit_speed movement, dash
        distance = movement.abs
        direction = movement.positive? ? 1 : -1
        limit = dash ? speed * 2 : speed
        distance > limit ? limit * direction : movement
    end

    def closest_foe
        foes.reject(&:dead).min { |foe| distance_to foe }
    end

    def displacement_to target
        target.position - position
    end
end
