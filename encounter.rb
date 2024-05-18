class Encounter
    attr_reader :monsters, :party

    def initialize monsters
        @monsters = monsters
    end

    def run party
        @party = party
        get_ready
        until over
            play_round
        end
    end

    private

    def play_round
        characters.sort_by(&:initiative).reverse.each do |character|
            character.take_turn unless character.dead
            break if over
        end
    end

    def over
        party.all?(&:dead) || monsters.all?(&:dead)
    end

    def get_ready
        party.each do |character|
            character.foes = monsters
        end
        monsters.each do |monster|
            monster.foes = party
        end
        characters.each &:roll_initiative
    end

    def characters
        party + monsters
    end

    def over
        party.all?(&:dead) || monsters.all?(&:dead)
    end
end
