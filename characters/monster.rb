require 'yaml'
require_relative 'character'

class Monster < Character
    attr_reader :aggressive

    Monsters = YAML.load(File.read 'monsters.yaml')

    def initialize key, position=30
        @character = Monsters[key]
        @aggressive = character['aggressive']
        super key, position
    end
end
