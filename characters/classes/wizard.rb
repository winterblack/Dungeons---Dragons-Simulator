require_relative '../player_character'

class Wizard < PlayerCharacter
    def initialize key
        super key, -30
    end
end
