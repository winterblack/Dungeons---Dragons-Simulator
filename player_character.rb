require 'yaml'
require_relative 'character'

class PlayerCharacter < Character
    Characters = YAML.load(File.read 'player_characters.yaml')

    def initialize key, position=0
        @character = Characters[key]
        super key, position
    end

    def aggressive
        false
    end
end
