
extends Node

var weapon_specials = [
	["No effect", 0],
	["Dedicated..", 2],
	["Drain", 3],
	["Elemental..", 0],
	["Keen Edge", 2],
	["Spell Effect", 2],
	["Stat Bonus..", 2],
	["Status Effect", 'x'],
	]

const SPECIAL_WEAPON_NONE = 0
const SPECIAL_WEAPON_DEDICATED_WEAPON = 1
const SPECIAL_WEAPON_DRAIN_WEAPON = 2
const SPECIAL_WEAPON_ELEMENTAL = 3
const SPECIAL_WEAPON_KEEN_EDGE = 4
const SPECIAL_WEAPON_SPELL_EFFECT = 5
const SPECIAL_WEAPON_STAT_BONUS = 6
const SPECIAL_WEAPON_STATUS_EFFECT = 7



class Armor:
	var name
	var set = ''
	var level
	var cost
	var type
	var HP_bonus
	var MP_bonus
	
	var specials
	
	func _init(name="[Armor]", level=1, cost=null,\
		type=1, HP_bonus=null, MP_bonus=null,\
		specials=[]):
		self.name = name
		self.level = level
		if !cost:	self.cost = self.get_cost()
		else:	self.cost = cost
		self.type = type
		if !HP_bonus:	self.HP_bonus = self.get_HP()
		else:	self.HP_bonus = HP_bonus
		if !MP_bonus:	self.MP_bonus = self.get_MP()
		else:	self.MP_bonus = MP_bonus
		self.specials = specials
	
	func get_cost():
		return Charts.armor_cost[self.level]
		
	func get_HP():
		return Charts.armor_chart[self.type][self.level][0]
	
	func get_MP():
		return Charts.armor_chart[self.type][self.level][1]




class Guard:
	var name
	var set = ''
	var level
	var cost
	var EVA_bonus
	var specials
	
	func _init(name="[Guard]", level=1, cost=null,\
			EVA_bonus=null, specials=[]):
		self.name = name
		self.level = level
		if !cost:	self.cost = self.get_cost()
		else:	self.cost = cost
		if !EVA_bonus:	self.EVA_bonus = self.get_EVA()
		else:	self.EVA_bonus = EVA_bonus
		self.specials = specials

	func get_EVA():
		return Charts.guard_chart[self.level]
	
	func get_cost():
		return Charts.guard_cost[self.level]



class Weapon:
	var name
	var set
	var level
	var cost
	var power_setting
	var AP
	var MAP
	var power_die
	var magic_die
	
	var specials
	var elements
	
	
	
	func _init(name="[WEAPON]", set="", level=1, cost=null, power_setting=[3,3],\
			AP=null, MAP=null, power_die=null, magic_die=null,\
			specials=[], elements=[]):
		self.name = name
		self.set = set
		self.level = level
		if !cost:	self.cost = self.get_cost()
		else:	self.cost = cost
		self.power_setting = power_setting
		if !AP:	self.AP = self.get_AP()
		else:	self.AP = AP
		if !MAP:	self.MAP = self.get_MAP()
		else:	self.MAP = MAP
		if !power_die:	self.power_die = self.get_power_die()
		else:	self.power_die = power_die
		if !magic_die:	self.magic_die = self.get_magic_die()
		else:	self.magic_die = magic_die
		self.specials = specials
		self.elements = elements

	func get_cost():
		return Charts.weapon_cost[self.level]

	func get_AP():
		return Charts.weapon_attack_chart[self.power_setting[0]][self.level]

	func get_MAP():
		return Charts.weapon_attack_chart[self.power_setting[1]][self.level]
	
	func get_power_die():
		return Charts.weapon_attack_dice[self.power_setting[0]]
	
	func get_magic_die():
		return Charts.weapon_attack_dice[self.power_setting[1]]