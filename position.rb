class Position
    attr_accessor :position

    def move_towards_closest_foe
        direction = direction_to closest_foe
        movement = speed * direction
        move movement
    end

    def direction_to target
        position < target.position ? 1 : -1
    end


    def distance_to target
        displacement_to(target).abs
    end

    def foes_within distance
        foes.select { |foe| distance_to(foe) < distance}
    end

    def move displacement
        self.position += displacement
    end

    private

    def closest_foe
        foes.reject(&:dead).min { |foe| distance_to foe }
    end

    def displacement_to target
        position - target.position
    end
end
