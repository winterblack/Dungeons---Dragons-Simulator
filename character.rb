require_relative 'dice'
require_relative 'position'

class Character < Position
    attr_reader :name, :ac, :hp, :speed, :level
    attr_reader :str, :dex, :con, :int, :wis, :cha
    attr_reader :proficiency_bonus
    attr_reader :weapon
    attr_reader :initiative
    attr_reader :character
    attr_accessor :current_hp, :dead
    attr_accessor :foes, :target

    def initialize key, position
        @name = key
        @ac = character['ac']
        @hp = @current_hp = character['hp']
        @speed = character['speed']
        @level = character['level']
        @str = Attribute.new character['str']
        @dex = Attribute.new character['dex']
        @con = Attribute.new character['con']
        @int = Attribute.new character['int']
        @wis = Attribute.new character['wis']
        @cha = Attribute.new character['cha']
        @weapon = Weapon.new character['weapon']
        @position = position
        set_proficiency_bonus
        equip_weapon
    end

    def roll_initiative
        @initiative = D20.roll
    end

    def take_turn
        action = choose_action
        action.perform
    end

    def take damage
        self.current_hp -= damage
        die if current_hp < 1
    end

    private

    def equip_weapon
        weapon.character = self
    end

    def choose_action
        weapon
    end

    def die
        self.dead = true
        p "#{name} dies"
    end

    def set_proficiency_bonus
        case level
        when 5..8
            @proficiency_bonus = 3
        when 9..12
            @proficiency_bonus = 4
        when 13..16
            @proficiency_bonus = 5
        when 17..20
            @proficiency_bonus = 6
        else
            @proficiency_bonus = 2
        end
    end
end
