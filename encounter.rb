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
            render_positions
            character.take_turn unless character.dead
            break if over
        end
    end

    def render_positions
        positions = (-16..16).to_a.reverse.map { |i| i*5 }
        positions.each do |position|
            characters_at_pos = characters.reject(&:dead).select { |char| char.position == position }
            chars = characters_at_pos.map { |char| "#{char.name} #{char.current_hp}/#{char.hp}" }.join(" - ")
            p "#{position} - #{chars}"
        end
        sleep 1
        system("echo \"\r#{"\033[1A\033[0K" * positions.count}\"")
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
