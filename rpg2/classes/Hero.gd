
extends Node

class Hero:
	
	var name
	var level = 1
	var XP = 0
	
	# Base stat scores (unmodified by items/effects/etc)
	var base_stats = {
		'strength':	8,
		'magic':	8,
		'vitality':	8,
		'spirit':	8,
		'agility':	8}
	# Stat choice weights for auto-stat increase @ lvl-up
	var stat_weights = {
		'strength':	8,
		'magic':	8,
		'vitality':	8,
		'spirit':	8,
		'agility':	8}
	
	var command_skill = null
	var support_skill = null
	
	var HP=0 setget _set_HP
	var MP=0 setget _set_MP
	
	var current_speed = 0
	
	var weapon = null
	var armor = null
	var guard = null
	var relic = null
	
	var elemental_affinity = [
		1,1,1,1,1,1,1,1]
	
	var status_effects = []


	# Initialization #
	func _init( name, level=1, XP=0,\
			HP=0,MP=0,\
			stats={'strength': 8, 'magic': 8, 'vitality': 8,\
					'spirit': 8, 'agility': 8},\
			stat_weights={'strength': 8, 'magic': 8, 'vitality': 8,\
					'spirit': 8, 'agility': 8},\
			command_skill=null, support_skill=null,\
			elements=[1,1,1,1,1,1,1,1],\
			status = []):
		self.name = name
		self.level = level
		self.XP = XP
		self.HP = HP
		self.MP = MP
		self.base_stats = stats
		self.stat_weights = stat_weights
		self.command_skill = command_skill
		self.support_skill = support_skill

		self.elemental_affinity = elements
		self.status_effects = []
		
		self.full_restore()
		
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


	#get stat bonus from level (+2 every 5)
	func _get_stat_bonus_from_lvl():
		var mod = int(self.level/5) * 2
		return(mod)



	# calculate maximum HP
	func get_max_HP():
		var base = 75
		var vitmult = 5
		if self.support_skill == "Toughness":
			base += 35; vitmult += 1
		var vit = self.get_stat('vitality') * vitmult
		var lvl = self.level * 4
		var armor = self.get_HP_from_armor()
		return base+vit+lvl+armor
	
	# calculate maximum MP
	func get_max_MP():
		var mental = 0
		if self.support_skill == "Mental Strength":
			mental = 5 + floor(self.get_stat('spirit') / 5)
		var spr = self.get_stat('spirit')
		var lvl = self.level * 2
		var armor = self.get_MP_from_armor()
		return mental + spr + lvl + armor

	# Restore HP/MP
	func full_restore():
		self.restore_HP()
		self.restore_MP()
	
	func restore_HP():
		self.set('HP', self.get_max_HP())
	
	func restore_MP():
		self.set('MP', self.get_max_MP())
	
	
	# Manage Status Effects
	func has_status( status ):
		if status in self.status_effects:
			return true
		return false
	
	func add_status_effect( status ):
		if not self.has_status(status):
			self.status_effects.append(status)
	
	func remove_status_effect( status ):
		if self.has_status(status):
			var id = self.status_effects.find(status)
			self.status_effects.remove(id)


	# Base stat setter/getter
	func set_stat( stat, value ):
		if stat in self.base_stats:
			self.base_stats[stat] = value
		
	func get_stat( stat ):
		if stat in self.base_stats:
			var value = self.base_stats[stat]
			value += _get_stat_bonus_from_lvl()
			return value


	# Get XP needed to attain level L
	func get_XP_to_level(L):
		if L <= 1:
			return 0
		else:
			L -= 2
			var xp = 50	#get to lvl 2
			for i in range(L):
				xp += 100*i
			return xp



	
	# Getters for standard equipment bonuses
	func get_AP_from_weapon():
		if self.weapon:
			return weapon.get_AP()
		return 0
	func get_MAP_from_weapon():
		if self.weapon:
			return weapon.get_MAP()
		return 0
	
	func get_HP_from_armor():
		if self.armor:
			return armor.get_HP()
		return 0
	
	func get_MP_from_armor():
		if self.armor:
			return armor.get_MP()
		return 0

	func get_EVA_from_guard():
		if self.guard:
			return guard.get_EVA()
		return 0

	#
	#	GET CALCULATED DERIVED SCORES
	#
	func get_attack_power():
		var str_bonus = self.get_stat('strength')
		var weapon_bonus = 0
		if self.equipped_weapon:
			weapon_bonus = self.get_AP_from_weapon()
		var total = str_bonus + weapon_bonus
		if self.support_skill == "Attack Up":
			total += 5 + floor( self.get_stat('strength') / 5 )
		return total
	
	func get_magic_attack_power():
		var mag_bonus = self.get_stat('magic')
		var weapon_bonus = 0
		if self.equipped_weapon:
			weapon_bonus = self.get_MAP_from_weapon()
		var total = mag_bonus + weapon_bonus
		if self.support_skill == "Magic Up":
			total += 5 + floor( self.get_stat('magic') / 5 )
		return total
	
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
	
	func get_max_tech_levels():
		var mag_bonus = floor( self.get_stat('magic') / 2 )
		return 5 + mag_bonus