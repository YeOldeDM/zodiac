
extends Node


class Hero:
	var name

	var level
	var xp = 0
	
	var base_strength
	var base_magic
	var base_vitality
	var base_spirit
	var base_agility
	
	var stat_weights = {
		'strength':	10,
		'magic':	1,
		'vitality':	15,
		'spirit':	1,
		'agility':	5
		}
	
	var command_skill=null
	var support_skill=null
	
	var current_HP=0
	var current_MP=0
	var current_speed=0
	
	var equipped_weapon = null
	var equipped_armor = null
	var equipped_guard = null
	var equipped_accessory = null
	
	var is_blocking = false
	var is_flying = false
#	var weakness = []
#	var resist = []
#	var immune = []
#	var absorb = []
	#
	#0=weakness: take double damage
	#1=normal: take normal damage
	#2=resist: take half damage
	#3=immune: take no damage
	#4=absorb: heal half damage
	#5=absorb+: heal all damage
	var elements = {
		'fire':1,
		'ice':1,
		'lightning':1
			}
	
	func _init(name="New Hero",level=1,xp=0,\
		strength=8,magic=8,vitality=8,spirit=8,agility=8,\
		stat_weights=null,\
		weapon=null,armor=null,guard=null,accessory=null,\
		elements = null):
			
		self.name = name
		self.level = level
		self.xp = xp
		
		self.base_strength = strength
		self.base_magic = magic
		self.base_vitality = vitality
		self.base_spirit = spirit
		self.base_agility = agility
		
		if stat_weights != null:
			self.stat_weights = stat_weights
		
		self.equipped_weapon = weapon
		self.equipped_armor = armor
		self.equipped_guard = guard
		
		if elements != null:
			self.elements = elements
		
		
	func get_package():
		var weapon = self.get_weapon()
		var armor = self.get_armor()
		var guard = self.get_guard()
		self.equipped_weapon = null
		self.equipped_armor = null
		self.equipped_guard = null
		var save_data = {
			'hero':	inst2dict(self),
			'weapon':	inst2dict(weapon),
			'armor':	inst2dict(armor),
			'guard':	inst2dict(guard)
			}
		self.equip_weapon(weapon)
		self.equip_armor(armor)
		self.equip_guard(guard)
		return save_data

	func get_name():
		return self.name

	func set_name(text):
		self.name = text
	
	func set_level(lvl):
		var diff = lvl - self.get_level()
		var stat_points = max(0, 3*diff)
		self.increase_stats(stat_points)
		self.level = lvl

	func get_level():
		return self.level
	
	func level_up():
		self.set_level(self.level+1)
	
	func get_XP():
		return self.xp

	func get_xp_to_level(L):
		if L <= 1:
			return 0
		else:
			L -= 2
			var xp = 50	#get to lvl 2
			for i in range(L):
				xp += 100*i
			return xp

	func set_strength(value):
		self.base_strength = value
	func set_magic(value):
		self.base_magic = value
	func set_vitality(value):
		self.base_vitality = value
	func set_spirit(value):
		self.base_spirit = value
	func set_agility(value):
		self.base_agility = value

	func _get_stat_from_lvl():
		var mod = int(self.get_level()/5) * 2
		return(mod)
	
	func get_weight(stat):
		return stat_weights[stat]

	func set_weight(stat,value):
		if stat in stat_weights:
			stat_weights[stat] = value
		else:
			print("BAD STAT SET FOR get_weights("+stat+")")
	
	func get_strength():
		return self.base_strength + _get_stat_from_lvl()
	func get_magic():
		return self.base_magic + _get_stat_from_lvl()
	func get_vitality():
		return self.base_vitality + _get_stat_from_lvl()
	func get_spirit():
		return self.base_spirit + _get_stat_from_lvl()
	func get_agility():
		return self.base_agility + _get_stat_from_lvl()
	
	func restore_full():
		self.restore_HP()
		self.restore_MP()
	
	func restore_HP():
		self.current_HP = get_HP()
	
	func restore_MP():
		self.current_MP = get_MP()
	
	func restore_speed():
		self.current_speed += self.get_speed()

	func get_HP():
		var base = 75
		var vitmult = 5
		if self.support_skill == "Toughness":
			base += 35; vitmult += 1
		var vit_bonus = self.get_vitality()*vitmult
		var lvl_bonus = self.get_level()*4
		var armor_bonus = self.get_armor_HP()
		return base + vit_bonus + lvl_bonus + armor_bonus
	
	func get_MP():
		var mental_strength = 0
		if self.support_skill == "Mental Strength":
			mental_strength = 5 + floor(self.get_spirit()/5)
		var spr_bonus = self.get_spirit()
		var lvl_bonus = self.get_level()*2
		var armor_bonus = self.get_armor_MP()
		return mental_strength + spr_bonus + lvl_bonus + armor_bonus

	func spend_speed(amt=8):
		self.current_speed -= amt
		if self.current_speed <= 0:
			self.current_speed = 0
		print(self.get_name()+" spent speed "+str(amt))

	func get_weapon_attack_power():
		var weapon = self.get_weapon()
		if weapon == null:
			return 0
		return weapon.get_attack_power()
	func get_weapon_magic_power():
		var weapon = self.get_weapon()
		if weapon == null:
			return 0
		return weapon.get_magic_power()
	
	func get_armor_HP():
		var armor = self.get_armor()
		if armor == null:
			return 0
		return armor.get_HP()

	func get_armor_MP():
		var armor = self.get_armor()
		if armor == null:
			return 0
		return armor.get_MP()
	
	func get_guard_evade():
		var guard = self.get_guard()
		if guard == null:
			return 0
		return guard.get_evade()

	func get_weapon():
		return self.equipped_weapon
	func get_armor():
		return self.equipped_armor

	func get_guard():
		return self.equipped_guard
	func get_accessory():
		return self.equipped_accessory
	
	func get_attack_power():
		var str_bonus = self.get_strength()
		var weapon_bonus = 0
		if self.equipped_weapon:
			weapon_bonus = self.get_weapon_attack_power()
		var total = str_bonus + weapon_bonus
		if self.support_skill == "Attack Up":
			total += 5+floor(self.get_strength()/5)
		return total
	
	func get_magic_attack_power():
		var mag_bonus = self.get_magic()
		var weapon_bonus = 0
		if self.equipped_weapon:
			weapon_bonus = self.get_weapon_magic_power()
		var total = mag_bonus + weapon_bonus
		if self.support_skill == "Magic Up":
			total += 5+floor(self.get_magic()/5)
		return total
	
	func get_strength_dice():
		var dice = floor(self.get_strength() / 100)
		return dice+1
	
	func get_magic_dice():
		var dice = floor(self.get_magic() / 100)
		return dice+1
	
	func get_accuracy():
		var agi_bonus = floor(self.get_agility() / 5)
		return 5 + agi_bonus
	
	func get_magic_accuracy():
		var mag_bonus = floor(self.get_magic() / 5)
		return 5 + mag_bonus
	
	func get_evade():
		var agi_bonus = floor(self.get_agility() / 5)
		var guard_bonus = self.get_guard_evade()
		return 25 + agi_bonus + guard_bonus
	
	func get_resist():
		var vit_bonus = floor(self.get_vitality() / 10)
		var spr_bonus = floor(self.get_spirit() / 10)
		return 25 + vit_bonus + spr_bonus
	
	func get_critical():
		var agi_bonus = floor(self.get_agility() / 15)
		return 2 + agi_bonus
	
	func get_speed():
		var agi_bonus = floor(self.get_agility() / 15)
		var lvl_bonus = floor(self.get_level() / 10)
		return 10 + agi_bonus + lvl_bonus
	
	func get_max_tech_levels():
		var mag_bonus = floor(self.get_magic() / 2)
	
	func equip_weapon(weapon):
		self.equipped_weapon = weapon
	
	func equip_armor(armor):
		self.equipped_armor = armor
	
	func equip_guard(guard):
		self.equipped_guard = guard
	
	func increase_stats(points):
		for i in range(points):
			var stat = self.find_random_stat()
			set('base_'+stat,get('base_'+stat)+1)
	
	func find_random_stat():
		var chances = []
		for stat in self.stat_weights:
			for i in range(self.stat_weights[stat]):
				chances.append(stat)
		var r = int(round(rand_range(0,chances.size()-1)))
		var result = chances[r]
		return result
	
	func fight(target):
		#assembles attack information and returns it as a list
		#[damage dealt, bool attack hits, bool attack auto-hits, bool is critical]
		var attack = Roll.attack(self.get_accuracy(),target.get_evade(),self.get_critical())
		var crit_mult = 2	#placeholder. Can be higher or set to 1 for critical-immunity
		var damage = Roll.damage(self.get_strength_dice(),self.get_weapon().get_attack_die(),self.get_attack_power(),\
								attack[2],crit_mult)
		attack.insert(0,damage)	#stick damage in as the first value in the list
		return attack

	func receive_attack(attack):
		if attack[1] or attack[2]:
			var damage = attack[0]
			if is_blocking:
				damage /= 2
			current_HP -= damage
			if current_HP <= 0:
				current_HP = 0
	