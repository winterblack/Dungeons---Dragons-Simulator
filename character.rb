require_relative 'dice'

class Character
    attr_reader :name, :ac, :hp, :speed
    attr_reader :initiative
    attr_accessor :current_hp, :dead
    attr_accessor :foes, :target

    def initialize options
        @name = options[:name]
        @ac = options[:ac]
        @current_hp = @hp = options[:hp]
        @speed = options[:speed]
    end

    def roll_initiative
        @initiative = D20.roll
    end

    def take_turn
        choose_target
        attack
    end

    def take damage
        self.current_hp -= damage
        die if current_hp < 1
    end

    private

    def choose_target
        @target = foes.reject(&:dead).max_by(&:initiative)
    end

    def attack
        D20.roll >= target.ac ? hit : miss
    end

    def hit
        damage = Dice('1d6').roll
        p "#{name} hit #{target.name} for #{damage} damage"
        target.take(damage)
    end

    def miss
        p "#{name} missed"
    end

    def die
        self.dead = true
        p "#{name} died"
    end
end
