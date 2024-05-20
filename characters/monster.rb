require 'yaml'
require_relative 'character'

class Monster < Character
    attr_reader :aggressive

    def initialize character, name
        @aggressive = character['aggressive']
        character['name'] = name
        super character, 30
    end
end
