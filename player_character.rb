require 'yaml'
require_relative 'character'
require_relative 'attribute'
require_relative 'weapon'

class PlayerCharacter < Character
    Characters = YAML.load(File.read 'player_characters.yaml')

    def initialize name, position=0
        character = Characters[name]
        @name = name
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
end
