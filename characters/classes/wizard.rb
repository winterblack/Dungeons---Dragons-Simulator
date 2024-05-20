require_relative '../player_character'
require_relative '../spellcaster'

class Wizard < PlayerCharacter
    include Spellcaster

    def initialize character
        super character, -30
    end
end
