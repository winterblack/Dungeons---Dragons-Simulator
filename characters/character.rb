require_relative '../dice'
require_relative 'position'
require_relative 'attribute'
require_relative '../actions/weapon'
require_relative '../actions/dash'

class Character < Position
    attr_reader :name, :ac, :hp, :speed, :level
    attr_reader :str, :dex, :con, :int, :wis, :cha
    attr_reader :proficiency_bonus
    attr_reader :weapon, :dash
    attr_reader :initiative
    attr_reader :character
    attr_accessor :current_hp, :dead
    attr_accessor :foes
    attr_accessor :reaction_available

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
        @weapon = Weapon.new character['weapon'], self
        @position = position
        @dash = Dash.new self
        @reaction_available = true
        set_proficiency_bonus
    end

    def heal healing
        max_healing = [hp - current_hp, healing].min
        self.current_hp += max_healing
        p "#{name} heals for #{max_healing} hp and is at #{current_hp}."
    end

    def opportunity_attack foe
        return if !reaction_available || foe.dead
        p "#{name} makes an opportunity attack against #{foe.name}"
        weapon.attack foe
        foe.position = position if foe.dead
        @reaction_available = false
    end

    def roll_initiative
        @initiative = D20.roll
    end

    def take_turn
        start_turn
        action = choose_action
        action.perform
    end

    def take damage
        self.current_hp -= damage
        die if current_hp < 1
    end

    private

    def start_turn
        reaction_available = true
    end

    def equip_weapon
        weapon.character = self
    end

    def choose_action
        weapon.valid_targets? ? weapon : dash
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

    def to_s
        "<#{name} hp=#{current_hp}/#{hp}>"
    end

    def inspect
        "<#{name} hp=#{current_hp}/#{hp}>"
    end
end
