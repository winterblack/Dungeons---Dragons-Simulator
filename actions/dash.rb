require_relative 'action'

class Dash < Action
    def perform
        character.dash_forward
    end
end
