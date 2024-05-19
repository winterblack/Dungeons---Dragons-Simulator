require 'yaml'
require_relative 'character'

class Monster < Character
    Monsters = YAML.load(File.read 'monsters.yaml')

    def initialize key, position=30
        @character = Monsters[key]
        super key, position
    end
end
