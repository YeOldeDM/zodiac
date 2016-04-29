
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
	
	#HERO INIT
	#All arguments here should have defaults, even if it's 'null'!
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
		
	#Return a packaged dict of all hero data
	func get_package():
		#reference current equipment
		#so we can re-equip it later
		var weapon = self.get_weapon()
		var armor = self.get_armor()
		var guard = self.get_guard()
		#unequip hero for clean packaging
		self.equipped_weapon = null
		self.equipped_armor = null
		self.equipped_guard = null
		#pack the data
		var save_data = {
			'hero':	inst2dict(self),
			'weapon':	inst2dict(weapon),
			'armor':	inst2dict(armor),
			'guard':	inst2dict(guard)
			}
		#re-equip hero
		self.equip_weapon(weapon)
		self.equip_armor(armor)
		self.equip_guard(guard)
		#return data
		return save_data
	
	#Hero name getset
	func get_name():
		return self.name
	func set_name(text):
		self.name = text
	
	#Hero level getset
	func get_level():
		return self.level
	func set_level(lvl):
		var diff = lvl - self.get_level()
		var stat_points = max(0, 3*diff)
		self.increase_stats(stat_points)
		self.level = lvl
	
	#level up the Hero
	func level_up():
		self.set_level(self.level+1)
	
	#get current XP
	func get_XP():
		return self.xp
	
	#get XP needed to attain level L
	func get_xp_to_level(L):
		if L <= 1:
			return 0
		else:
			L -= 2
			var xp = 50	#get to lvl 2
			for i in range(L):
				xp += 100*i
			return xp
	
	#Stat getset
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


	#get stat bonus from level (+2 every 5)
	func _get_stat_from_lvl():
		var mod = int(self.get_level()/5) * 2
		return(mod)
	
	#Stat weight getset
	#weight is used to decide stat
	#improvements on level-up
	func get_weight(stat):
		return stat_weights[stat]

	func set_weight(stat,value):
		if stat in stat_weights:
			stat_weights[stat] = value
		else:
			print("BAD STAT SET FOR get_weights("+stat+")")
	
	#randomly distribute points among stats,
	#based on weights
	func increase_stats(points):
		for i in range(points):
			var stat = self.find_random_stat()
			set('base_'+stat,get('base_'+stat)+1)
	#find a random stat based on weights
	func find_random_stat():
		var chances = []
		for stat in self.stat_weights:
			for i in range(self.stat_weights[stat]):
				chances.append(stat)
		var r = int(round(rand_range(0,chances.size()-1)))
		var result = chances[r]
		return result

	#is the Hero flying?
	func is_flying():
		if self.support_skill == 'Flight':
			return true
		return false

	#is the Hero below 25% HP?
	func needs_cover():
		if self.get_HP_percent() < 0.25:
			return true
		return false
	
	#Restore HP/MP
	func restore_full():
		self.restore_HP()
		self.restore_MP()
	
	#Restore HP
	func restore_HP():
		self.current_HP = get_HP()
	
	#Restore MP
	func restore_MP():
		self.current_MP = get_MP()
	
	#Add Speed stat to current Speed
	func restore_speed():
		self.current_speed += self.get_speed()
	
	func set_initial_speed():
		var S = get_speed()
		var R = int(round(rand_range(1,8)))
		self.current_speed = S+R

	#get current HP %
	func get_HP_percent():
		return (self.current_HP*1.0)/(self.get_HP()*1.0)
	
	#get calculated maximum HP
	func get_HP():
		var base = 75
		var vitmult = 5
		if self.support_skill == "Toughness":
			base += 35; vitmult += 1
		var vit_bonus = self.get_vitality()*vitmult
		var lvl_bonus = self.get_level()*4
		var armor_bonus = self.get_armor_HP()
		return base + vit_bonus + lvl_bonus + armor_bonus
	
	#get calculated maximum MP
	func get_MP():
		var mental_strength = 0
		if self.support_skill == "Mental Strength":
			mental_strength = 5 + floor(self.get_spirit()/5)
		var spr_bonus = self.get_spirit()
		var lvl_bonus = self.get_level()*2
		var armor_bonus = self.get_armor_MP()
		return mental_strength + spr_bonus + lvl_bonus + armor_bonus
	
	#Spend speed points in battle (default 8)
	func spend_speed(amt=8):
		self.current_speed -= amt
		if self.current_speed <= 0:
			self.current_speed = 0
		print(self.get_name()+" spent speed "+str(amt))
	
	#equip weapon object
	func equip_weapon(weapon):
		self.equipped_weapon = weapon
	#equip armor object
	func equip_armor(armor):
		self.equipped_armor = armor
	#equip guard object
	func equip_guard(guard):
		self.equipped_guard = guard

	#get current weapon's AP bonus
	func get_weapon_attack_power():
		var weapon = self.get_weapon()
		if weapon == null:
			return 0
		return weapon.get_attack_power()
	#get current weapon's MAP bonus
	func get_weapon_magic_power():
		var weapon = self.get_weapon()
		if weapon == null:
			return 0
		return weapon.get_magic_power()
	#get current armor's HP bonus
	func get_armor_HP():
		var armor = self.get_armor()
		if armor == null:
			return 0
		return armor.get_HP()
	#get current armor's MP bonus
	func get_armor_MP():
		var armor = self.get_armor()
		if armor == null:
			return 0
		return armor.get_MP()
	#get current guard's EVA bonus
	func get_guard_evade():
		var guard = self.get_guard()
		if guard == null:
			return 0
		return guard.get_evade()
	#get equipped weapon's object
	func get_weapon():
		return self.equipped_weapon
	#get equipped armor's object
	func get_armor():
		return self.equipped_armor
	#get guard's object
	func get_guard():
		return self.equipped_guard
	#get accessory object(TBA)
	func get_accessory():
		return self.equipped_accessory
	
	#
	#	GET CALCULATED DERIVED SCORES
	#
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
		var base = 10
		if self.support_skill == "Quickness":
			base += 2
		var agi_bonus = floor(self.get_agility() / 15)
		var lvl_bonus = floor(self.get_level() / 10)
		return base + agi_bonus + lvl_bonus
	
	func get_max_tech_levels():
		var mag_bonus = floor(self.get_magic() / 2)
	

	

	
	func fight(target):
		#assembles attack information and returns it as a list
		#[damage dealt, bool attack hits, bool attack auto-hits, bool is critical]
		var attack = Roll.attack(self.get_accuracy(),target.get_evade(),self.get_critical())
		var crit_mult = 2	#placeholder. Can be higher or set to 1 for critical-immunity
		var damage = Roll.damage(self.get_strength_dice(),self.get_weapon().get_attack_die(),self.get_attack_power(),\
								attack[2],crit_mult)
		attack.insert(0,damage)	#stick damage in as the first value in the list
		return attack

	#process an incoming attack
	#take damage if needed and check for death
	func receive_attack(attack):
		if attack[1] or attack[2]:
			var damage = attack[0]
			if is_blocking:
				damage /= 2
			current_HP -= damage
			if current_HP <= 0:
				current_HP = 0
	