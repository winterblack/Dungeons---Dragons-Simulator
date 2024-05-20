module SecondWind
    attr_accessor :second_wind_available

    def start_turn
        use_second_wind if current_hp < hp && second_wind_available
        super
    end

    def use_second_wind
        p "#{name} uses second wind"
        healing = healing_dice.roll + level
        heal healing
        second_wind_available = false
    end

    private

    def healing_dice
        Dice.new '1d10'
    end
end
