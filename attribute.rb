class Attribute
    attr_reader :value, :bonus

    def initialize value
        @value = value
        @bonus = value < 10 ? (value - 11) / 2 : (value - 10) / 2
    end
end

class Integer
    alias_method :add, :+

    def + addend
        addend.is_a?(Attribute) ? self.add(addend.bonus) : self.add(addend)
    end
end

class Float
    alias_method :add, :+

    def + addend
        addend.is_a?(Attribute) ? self.add(addend.bonus) : self.add(addend)
    end
end
