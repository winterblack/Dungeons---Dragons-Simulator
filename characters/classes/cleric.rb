require_relative '../player_character'

class Cleric < PlayerCharacter
    include Spellcaster

    def initialize character
        super character, 0
        set_spell_slots
    end
end
