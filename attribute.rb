class Attribute
    attr_reader :value, :bonus

    def initialize value
        @value = value
        @bonus = value < 10 ? (value - 11) / 2 : (value - 10) / 2
    end
end
