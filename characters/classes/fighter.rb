require_relative '../player_character'
require_relative '../class_features/second_wind'

class Fighter < PlayerCharacter
    def initialize key
        super key, 0
        extend SecondWind
        @second_wind_available = true
    end
end
