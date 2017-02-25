
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
	var max_HP
	var max_MP
	
	var current_speed = 0
	
	var elemental_affinity = [
		1,1,1,1,1,1,1,1]
	
	var status_effects = []
	
	var has_flight = false
	
	func _init(name, level=1,is_boss=false,\
		physical_die=8,magical_die=8,\
		stats = {
		'strength':	8,
		'magic':	8,
		'vitality':	8,
		'spirit':	8,
		'agility':	8},\
		elemental_affinity=[1,1,1,1,1,1,1,1],\
		status_effects = [],\
		maxHP=null, maxMP=null):
		
		
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
		
		# set standardized HP MP if overrides aren't provided
		if !maxHP:	self.max_HP = self.get_max_HP()
		else:	self.max_HP = maxHP
		if !maxMP:	self.max_MP = self.get_max_MP()
		else:	self.max_MP = maxMP
		
	
	
	
	
	
		# HP setter/getter
	func _set_HP( value ):
		HP = clamp(value,0,self.get_max_HP())

	func check_for_death():
		if HP <= 0:
			self.add_status_effect(RPG.STATUS_DEATH)
			return true
		return false
	
	func _get_HP():
		return HP



	# MP setter/getter
	func _set_MP( value ):
		MP = clamp(value,0,self.get_max_MP())
	
	func _get_MP():
		return MP

	# Restore HP/MP
	func full_restore():
		self.restore_HP()
		self.restore_MP()
	
	func restore_HP():
		self.set('HP', self.get_max_HP())
	
	func restore_MP():
		self.set('MP', self.get_max_MP())


	func refresh_speed(init=false):
		# Add Spd stat to current speed
		self.current_speed += self.get_speed()
		if init:	current_speed += Roll.die(1,8)


	func is_flying():
		return has_flight

	# Manage Status Effects
	
	# check if we have a status effect
	func has_status_effect( status ):
		if status in self.status_effects:
			return true
		return false
	
	# add status effect
	func add_status_effect( status ):
		if !self.has_status_effect(status):
			# ..only if we don't already have this status..
			self.status_effects.append(status)
	
	# remove status effect
	func remove_status_effect( status ):
		if self.has_status(status):
			var id = self.status_effects.find(status)
			self.status_effects.remove(id)
	
	# clear all status effects
	func clear_status_effects():
		self.status_effects = []




	# Stat getter
	func get_stat( stat ):
		if stat in self.stats:
			return self.stats[stat]
	
	# Stat setter
	func set_stat( stat, value ):
		if stat in self.stats:
			self.stats[stat] = int(value)
	
	
	
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
		var total = 30+vit+lvl
		if self.is_boss:	return 10 * total
		return total
	
	# Get monster standard max MP value
	func get_max_MP():
		var spr = self.get_stat('spirit')
		var lvl = self.level
		var total = int((spr+lvl)/2)
		if self.is_boss:	return 2 * total
		return total
	
	
	func get_weapon_damage(die_mod=0, AP_mult=1.0):
		var dice = self.get_strength_dice()
		var sides = self.physical_die+(die_mod*2)
		var AP = self.get_attack_power()*AP_mult
		return Roll.damage(dice, sides)+AP
	
	func get_weapon_range():
		# Return True if current weapon is melee range
		return true
	
	# Get Derived stats..

	func get_derived_score( stat ):
		var st = 'get_'+stat
		if self.has_method(st):
			return self.call(st)


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
		return 25 + agi_bonus
	
	func get_resist():
		var vit_bonus = floor( self.get_stat('vitality') / 10 )
		var spr_bonus = floor( self.get_stat('spirit') / 10 )
		return 25 + vit_bonus + spr_bonus
	
	func get_critical():
		var agi_bonus = floor( self.get_stat('agility') / 15 )
		return 2 + agi_bonus
	
	func get_speed():
		var base = 10
		var agi_bonus = floor( self.get_stat('agility') / 15 )
		var lvl_bonus = floor( self.level / 10 )
		return base + agi_bonus + lvl_bonus



	func take_damage(damage, element):
		var new_HP = self.HP - damage
		self.set('HP', new_HP)
		check_for_death()




