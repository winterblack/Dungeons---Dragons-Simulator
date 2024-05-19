class Dice
    attr_reader :count, :type

    def initialize expression, crit
        parts = expression.split('d').map(&:to_i)
        @count = crit ? parts.first * 2 : parts.first
        @type = parts.last
    end

    def roll
        count.times.collect { rand 1..type }.sum
    end
end

class D20
    def self.roll
        rand 1..20
    end
end

def Dice expression, crit=false
    Dice.new expression, crit
end
