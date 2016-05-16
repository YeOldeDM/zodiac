
extends Node

class Actor:
	var name='' setget _set_name, _get_name
	var level = 1 setget _set_level, _get_level
	
	var stats
	var hero
	var monster
	
	func _init(name, level, stats,\
				hero=null, monster=null):
		self.name = name
		self.level = level
		self.stats = stats
		self.hero = hero
		self.monster = monster
		
		self.stats.owner = self
		if self.hero:
			self.hero.owner = self
		if self.monster:
			self.monster.owner = self

	func _set_name(txt):
		 name = txt
	
	func _get_name():
		return name.capitalize()

	func is_hero():
		if self.hero:
			return true
		return false
	func is_monster():
		if self.monster:
			return true
		return false


class Stats:
	var strength
	var magic
	var vitality
	var spirit
	var agility
	
	func _init(strength=8, magic=8, vitality=8,\
				spirit=8, agility=8):
		self.strength = strength
		self.magic = magic
		self.vitality = vitality
		self.spirit = spirit
		self.agility = agility

class Hero:
	var owner
	
	var XP = 0 setget _set_XP, _get_XP
	
	func _init(owner):
		self.owner = owner

	func _set_XP(amt):
		XP = amt
#		if XP >= self.get_XP_to_next():
#			self.levelUp()

	func _get_XP():
		return XP #self.get_XP_to_next()