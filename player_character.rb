require 'yaml'
require_relative 'character'
require_relative 'attribute'
require_relative 'weapon'

class PlayerCharacter < Character
    Characters = YAML.load(File.read 'player_characters.yaml')

    def initialize key, position=0
        @character = Characters[key]
        super key, position
    end
end
