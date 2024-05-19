require 'yaml'
require_relative 'character'
require_relative 'attribute'
require_relative 'weapon'

class Monster < Character
    Monsters = YAML.load(File.read 'monsters.yaml')

    def initialize name, position=30
        monster = Monsters[name]
        @name = name
        @ac = monster['ac']
        @hp = @current_hp = monster['hp']
        @speed = monster['speed']
        @level = monster['challenge']
        @str = Attribute.new monster['str']
        @dex = Attribute.new monster['dex']
        @con = Attribute.new monster['con']
        @int = Attribute.new monster['int']
        @wis = Attribute.new monster['wis']
        @cha = Attribute.new monster['cha']
        @weapon = Weapon.new monster['weapon']
        @position = position
        set_proficiency_bonus
        equip_weapon
    end
end
