
extends Node

class Monster:
	var name
	var level
	
	var is_boss = false
	
	var XP_value
	var GP_value
	
	var stats = {
		'strength':	8,
		'magic':	8,
		'vitality':	8,
		'spirit':	8,
		'agility':	8}
	
	var physical_die = 8
	var magical_die = 8
	
	var HP setget _set_HP
	var MP setget _set_MP
	
	var elemental_affinity = [
		1,1,1,1,1,1,1,1]
	
	var status_effects = []
	
	func _init(name, level=1,is_boss=false,\
		physical_die=8,magical_die=8,\
		stats = {
		'strength':	8,
		'magic':	8,
		'vitality':	8,
		'spirit':	8,
		'agility':	8},\
		elemental_affinity=[1,1,1,1,1,1,1,1],\
		status_effects = []):
		self.name = name
		self.level = level
		self.is_boss = is_boss
		self.stats = stats
		self.elemental_affinity = elemental_affinity
		self.status_effects = status_effects
		
		self.XP_value = self.get_XP_value()
		self.GP_value = self.get_GP_value()
		self.HP = self.get_max_HP()
		self.MP = self.get_max_MP()
	
		# HP setter/getter
	func _set_HP( value ):
		HP = clamp(value,0,self.get_max_HP())
		if HP <= 0:
			self.add_status_effect(RPG.STATUS_DEATH)
	
	func _get_HP():
		return HP

	# MP setter/getter
	func _set_MP( value ):
		MP = clamp(value,0,self.get_max_MP())
	
	func _get_MP():
		return MP


	# Stat getter
	func get_stat( stat ):
		if stat in self.stats:
			return self.stats[stat]
	
	# Get monster standard XP value
	func get_XP_value():
		var mult = 35
		if self.is_boss: mult = 150
		return self.level * mult
	
	# Get monster standard GP value
	func get_GP_value():
		var mult = 15
		if self.is_boss: mult = 75
		return self.level * mult
	
	# Get monster standard max HP value
	func get_max_HP():
		var vit = self.get_stat('vitality')*20
		var lvl = self.level*10
		return 30+vit+lvl
	
	# Get monster standard max MP value
	func get_max_MP():
		var spr = self.get_stat('spirit')
		var lvl = self.level
		return int((spr+lvl)/2)
	
	# Get Derived stats..
	func get_attack_power():
		return self.get_stat('strength')*2
	
	func get_magic_attack_power():
		return self.get_stat('magic')*2
	
	func get_strength_dice():
		var dice = floor( self.get_stat('strength') / 100 )
		return dice + 1
	
	func get_magic_dice():
		var dice = floor( self.get_stat('magic') / 100 )
		return dice + 1
	
	func get_accuracy():
		var agi_bonus = floor( self.get_stat('agility') / 5 )
		return 5 + agi_bonus
	
	func get_magic_accuracy():
		var mag_bonus = floor( self.get_stat('magic') / 5 )
		return 5 + mag_bonus
	
	func get_evade():
		var agi_bonus = floor( self.get_stat('agility') / 5 )
		var guard_bonus = self.get_EVA_from_guard()
		return 25 + agi_bonus + guard_bonus
	
	func get_resist():
		var vit_bonus = floor( self.get_stat('vitality') / 10 )
		var spr_bonus = floor( self.get_stat('spirit') / 10 )
		return 25 + vit_bonus + spr_bonus
	
	func get_critical():
		var agi_bonus = floor( self.get_stat('agility') / 15 )
		return 2 + agi_bonus
	
	func get_speed():
		var base = 10
		if self.support_skill == "Quickness":
			base += 2
		var agi_bonus = floor( self.get_stat('agility') / 15 )
		var lvl_bonus = floor( self.level / 10 )
		return base + agi_bonus + lvl_bonus

	func get_fight_damage():
		var dice = self.get_strength_dice()
		var sides = self.physical_die
		var atk = self.get_attack_power()
		return Roll.damage(dice, sides)+atk