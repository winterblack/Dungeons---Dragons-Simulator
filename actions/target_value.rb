class TargetValue
    attr_reader :target, :value

    def initialize target, value
        @target = target
        @value = value
    end

    def to_s
        "<TargetValue target=#{target} value=#{value}>"
    end

    def inspect
        "<TargetValue target=#{target} value=#{value}>"
    end
end
