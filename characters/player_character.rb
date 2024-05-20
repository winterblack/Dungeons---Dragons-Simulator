require_relative 'character'

class PlayerCharacter < Character
    def initialize character, position
        super character, position
    end

    def aggressive
        false
    end
end
